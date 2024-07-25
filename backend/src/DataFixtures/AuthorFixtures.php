<?php

namespace App\DataFixtures;

use App\Entity\Author;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class AuthorFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $author1 = new Author();
        $author1
            ->setFirstName("Author 1")
            ->setLastName("Author 1")
            ->setBirthday(new \DateTime("1990-01-01"))
            ->setGender("M")
        ;
        $manager->persist($author1);

        $manager->flush();

        $this->addReference('author1', $author1);
    }
}
