<?php

namespace App\Model;
use Symfony\Component\Validator\Constraints as Assert;

class AuthorDto
{
    public function __construct(
        #[Assert\NotBlank]
        public string $firstName,
        #[Assert\NotBlank]
        public string $lastName,
        public string $birthday,
        public string $gender,
    ) {
    }
}