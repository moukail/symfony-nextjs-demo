'use client'
import useSWR from "swr";
import {DataGrid, GridColDef} from "@mui/x-data-grid";
import api, {fetcher} from "@/api";

export default function AuthorList() {
    const { data, error, isLoading } = useSWR('/authors', fetcher)

    const colums: GridColDef[] = [
        {field: 'firstName', headerName: 'First Name'},
        {field: 'lastName', headerName: 'Last Name'},
        {field: 'gender', headerName: 'Gender'},
        {field: 'birthday', headerName: 'birthday'},
    ]

    if (isLoading) {
        return <span>Loading...</span>
    }

    if (error) {
        return <span>{error.message}</span>
    }

    return(
        <DataGrid columns={colums} rows={data} getRowId={row => row.id}/>
    );
}