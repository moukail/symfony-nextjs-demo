<?php

namespace App\Controller;

use App\Entity\Author;
use App\Entity\Book;
use App\Model\AuthorDto;
use App\Service\AuthorService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

class AuthorController extends AbstractController
{
    public function __construct(private readonly AuthorService $authorService)
    {}

    #[Route('/api/v1/authors', name: 'app_author', methods: ['GET'])]
    public function index(): JsonResponse
    {
        return $this->json($this->authorService->getAuthors(), Response::HTTP_OK, [], [
            'groups' => ['user'],
        ]);
    }

    #[Route('/api/v1/authors/{id}', name: 'app_author_show', methods: ['GET'])]
    public function show(Author $author): JsonResponse
    {
        return $this->json($author, Response::HTTP_OK, [], ['groups' => ['user']]);
    }

    #[Route('/api/v1/authors', name: 'app_author_create', methods: ['POST'])]
    public function create(#[MapRequestPayload] AuthorDto $authorDto): JsonResponse
    {
        $author = $this->authorService->create($authorDto);
        return $this->json($author, Response::HTTP_CREATED, [], ['groups' => ['user']]);
    }

    #[Route('/api/v1/authors/{id}/edit', name: 'app_author_edit', methods: ['PUT'])]
    public function edit(Author $author, #[MapRequestPayload] AuthorDto $authorDto): JsonResponse
    {
        $author = $this->authorService->update($author, $authorDto);
        return $this->json($author, Response::HTTP_OK, [], ['groups' => ['user']]);
    }

    #[Route('/api/v1/authors/{id}', name: 'app_author_delete', methods: ['DELETE'])]
    public function delete(Author $author): JsonResponse
    {
        $this->authorService->delete($author);
        return $this->json(null, Response::HTTP_NO_CONTENT);
    }
}
