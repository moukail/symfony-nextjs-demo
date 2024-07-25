import AuthorList from "@/components/AuthorList";
import {Grid, Paper} from "@mui/material";
import AuthorAdd from "@/components/AuthorAdd";

export default function Page() {

    return(
        <Grid container spacing={3}>
            <Grid item xs={12} md={8} lg={6}>
                <Paper
                    sx={{
                        p: 2,
                        display: 'flex',
                        flexDirection: 'column',
                    }}
                >
                    <h1>Authors</h1>
                    <AuthorList/>
                </Paper>
            </Grid>
            <Grid item xs={12} md={4} lg={6}>
                <Paper
                    sx={{
                        p: 2,
                        display: 'flex',
                        flexDirection: 'column',
                    }}
                >
                    <h1>Add Author</h1>
                    <AuthorAdd/>
                </Paper>
            </Grid>
        </Grid>
    );
}
