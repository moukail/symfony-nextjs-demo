<?php

namespace App\Service;

use App\Entity\Author;
use App\Model\AuthorDto;
use App\Repository\AuthorRepository;

class AuthorService
{
    public function __construct(private readonly AuthorRepository $authorRepository)
    {}
    
    public function getAuthors(): array
    {
        return $this->authorRepository->findAll();
    }

    public function create(AuthorDto $authorDto): Author
    {
        $author = new Author();
        $author
            ->setFirstName($authorDto->firstName)
            ->setLastName($authorDto->lastName)
            //->setBirthday($authorDto->birthday)
            ->setGender($authorDto->gender)
        ;

        $this->authorRepository->save($author);
        return $author;
    }

    public function delete(Author $author): void
    {
        $this->authorRepository->delete($author);
    }

    public function update(Author $author, AuthorDto $authorDto): Author
    {
        $author->setName($authorDto->name);
        $this->authorRepository->save($author);
        return $author;
    }
}