<?php

namespace App\DataFixtures;

use App\Entity\Author;
use App\Entity\Book;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class BookFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $book1 = new Book();
        $book1
            ->setTitle("Book 1")
            ->addAuthor($this->getReference("author1", Author::class))
        ;
        $manager->persist($book1);

        $manager->flush();
    }
}
