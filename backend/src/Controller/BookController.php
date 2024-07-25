<?php

namespace App\Controller;

use App\Entity\Book;
use App\Service\BookService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class BookController extends AbstractController
{
    public function __construct(private readonly BookService $bookService)
    {}

    #[Route('/api/v1/books', name: 'app_book')]
    public function index(): JsonResponse
    {
        return $this->json($this->bookService->getBooks(), Response::HTTP_OK, [], ['groups' => ['user']]);
    }
    #[Route('/api/v1/books/{id}', name: 'app_book_show')]
    public function show(Book $book): JsonResponse
    {
        return $this->json($book, Response::HTTP_OK, [], ['groups' => ['user']]);
    }
}
