import Link from "next/link";

export default function Page({ params }: { params: { id: string }}) {
    return(
        <>
            <h1>Author: {params.id}</h1>
            <Link href="/about">About</Link>
        </>
    );
}
