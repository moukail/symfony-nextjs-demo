<?php

namespace App\Service;

use App\Entity\Book;
use App\Repository\BookRepository;

class BookService
{
    public function __construct(private readonly BookRepository $bookRepository)
    {}

    public function getBooks(): array
    {
        return $this->bookRepository->findAll();
    }

    public function create(Book $book): void
    {
        $this->bookRepository->save($book);
    }
}