<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class PageController extends AbstractController
{
    #[Route('/', name: 'home')]
    public function index(): Response
    {
        return $this->render('pages/index.html.twig');
    }

    #[Route('/transport', name: 'transport')]
    public function transport(): Response
    {
        return $this->render('pages/transport.html.twig');
    }

    #[Route('/spedycja', name: 'spedycja')]
    public function spedycja(): Response
    {
        return $this->render('pages/spedycja.html.twig');
    }

    #[Route('/logistyka', name: 'logistyka')]
    public function logistyka(): Response
    {
        return $this->render('pages/logistyka.html.twig');
    }

    #[Route('/wspolpraca', name: 'wspolpraca')]
    public function wspolpraca(): Response
    {
        return $this->render('pages/wspolpraca.html.twig');
    }
}
