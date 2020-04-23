<?php
namespace App\Controller;

use App\Entity\Cour;
use App\Entity\Matiere;
use App\Entity\Etudiant;
use App\Entity\Promotion;
use App\Form\EtudiantType;
use App\Repository\CourRepository;
use App\Repository\AbsenceRepository;
use App\Repository\MatiereRepository;
use App\Repository\EtudiantRepository;
use Knp\Component\Pager\PaginatorInterface;
use Doctrine\DBAL\Exception\DriverException;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class EcoleController extends AbstractController
{

    /**
    * @Route("/", name="home")
    */
    public function home(Request $req)
    {    
        return $this->render('pages/home.html.twig',['user'=>$this->get('session')->get('user')]);
    }
    
    /**
    * @Route("/connexion", name="connexion")
    */
    public function connexion(Request $req,EtudiantRepository $repo) 
    { 
       
        $etudiants = $repo->findAll();
        $email=$req->request->get('email');
        $password=$req->request->get('password');
        if(count($etudiants)>0)foreach($etudiants as $etu)
        {
            if($etu->getEmail()==$email && password_verify($password,$etu->getPassword()))
            {
                $this->get('session')->set('user', $etu);
                return $this->redirectToRoute('home');
            }
         }
        return $this->render('pages/connexion.html.twig',['user'=>$this->get('session')->get('user')]);
    }

    /**
    * @Route("/deconexion", name="deconexion")
    */
    public function deconexion(Request $req) 
    { 
        $this->get('session')->set('user', null);
        return $this->redirectToRoute('connexion');
    }

    /**
    * @Route("/about", name="about")
    */
    public function about() 
    {  
        return $this->render('pages/about.html.twig',['user'=>$this->get('session')->get('user')]);  
    }
    
    /**
    * @Route("/matieres", name="matieres")
    */
    public function matieres(Request $req,PaginatorInterface $paginator,MatiereRepository $repo) 
    {
        if($this->get('session')->get('user') != null)
        {
        $donnees = $repo->findAllOrderById();
        $matieres = $paginator->paginate(
            $donnees,//on passe les donner
            $req->query->getInt('page',1),// numero de la page en cours ,par default 1
            6 // le nombre d'element par page
        );
        return $this->render('pages/matieres.html.twig',[
            'matieres'=>$matieres,
            'user'=>$this->get('session')->get('user')
        ]);
        }
        return $this->redirectToRoute('connexion');
    }

    /**
    * @Route("/matieres/{id}", name="cour")
    */
    public function cour($id,CourRepository $repoCour,MatiereRepository $repoMatiere) 
    {
        // a revoir
        try{
            $cours = $repoCour->findByMatiere($id);
            $matier = $repoMatiere->findOneById($id);
            return $this->render('pages/cours.html.twig',[
                'cours'=>$cours,
                'matiere'=>$matier,
                'user'=>$this->get('session')->get('user')
                ]);
        }catch (DriverException $e){
            return $this->redirectToRoute('matieres');
        }
    }

    /**
    * @Route("/equipe", name="equipe")
    */
    public function equipe() 
    {
        if($this->get('session')->get('user') != null)
        {
            return $this->render('pages/equipe.html.twig',['user'=>$this->get('session')->get('user')]);
        }
        return $this->redirectToRoute('connexion');
    }

    /**
    * @Route("/etudiant", name="etudiant")
    */
    public function etudiant(Request $req,EtudiantRepository $repo) 
    {
        $etudiants = $repo->findAll();
        $etudiant = $this->get('session')->get('user') == null ? new Etudiant() : $repo->find($this->get('session')->get('user')->getId());
        $form = $this->createForm(EtudiantType::class,$etudiant);
        $form->handleRequest($req);
        $passewordConfirm = $req->request->get('confirmPassword')==$etudiant->getPassword();
        if($form->isSubmitted() && $form->isValid() && $passewordConfirm)
         {
            if(count($etudiants)>0 && $this->get('session')->get('user') == null)foreach($etudiants as $etu)
            {
                //je verifier si l'email n'existe pas dans la base de donnee si user est null(nouvelle inscription)
                if($etu->getEmail()==$etudiant->getEmail())
                    return $this->redirectToRoute('etudiant');
             }
            $entityManager = $this->getDoctrine()->getManager();
            //hashage de mot de passe 
            $etudiant->setPassword(password_hash($etudiant->getPassword(), PASSWORD_DEFAULT));
            //si tout va bien je enrigitre dans la table etudiant 
            $entityManager->persist($etudiant);
            $entityManager->flush();
            $this->get('session')->set('user', $etudiant);
          
            
        }
       
        return $this->render('pages/etudiant.html.twig',[
           'form'=>$form->createView(),
           'user'=>$this->get('session')->get('user'),
           'isSubmit'=>$form->isSubmitted(),
           'passewordConfirm'=> $passewordConfirm
        ]);
    }
    
    /**
    * @Route("/abscences", name="abscences")
    */
    public function abscenses(AbsenceRepository $repoAbscence,CourRepository $repoCour) 
    {  
        if($this->get('session')->get('user') != null)
        {
            $abscences = $repoAbscence->findByEtudiant($this->get('session')->get('user'));
            return $this->render('pages/abscences.html.twig',[
                'user'=>$this->get('session')->get('user'),
                'abscences'=>$abscences
                ]);
        }
        return $this->redirectToRoute('connexion'); 
    }
}
