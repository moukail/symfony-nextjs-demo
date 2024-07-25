<?php

namespace App\DataFixtures;

use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class UserFixtures extends Fixture
{
    public function __construct(private UserPasswordHasherInterface $passwordHasher)
    {}

    public function load(ObjectManager $manager): void
    {
        $user = new User();
        $user->setEmail('admin1@test.nl');
        //$random = random_bytes(10);
        $password = $this->passwordHasher->hashPassword($user, 'pass_1234');
        $user->setPassword($password);
        $user->setRoles(['ROLE_ADMIN']);
        //$user->setActive(true);
        //$user->setFirstName('manager');
        //$user->setLastName('manager');
        $manager->persist($user);

        $manager->flush();
    }
}