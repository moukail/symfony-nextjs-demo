'use client'
import {
    FormControlLabel,
    FormHelperText,
    FormLabel,
    Grid,
    Input,
    InputLabel, Radio,
    RadioGroup,
    TextField
} from "@mui/material";
import {FormControl} from "@mui/base";
import {LoadingButton} from "@mui/lab";
import SaveIcon from "@mui/icons-material/Save";
import React, {useState} from "react";
import {Author} from "@/types/author.type";
import api from "@/api";
import {mutate} from "swr";
import Box from "@mui/material/Box";

export default function AuthorAdd() {

    const [author, setAuthor] = useState<Author>({
        firstName: '',
        lastName: '',
        birthday: '',
        gender: 'other'
    });

    const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = event.target;
        setAuthor({...author, [name]: value});
    }

    const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        try {
            await api.post('/authors', author);
            mutate('/authors'); // Optional: revalidate SWR cache if you have a list of authors
            setAuthor({ firstName: '', lastName: '', birthday: '', gender: 'other' });
        } catch (error) {
            console.error('Failed to create author:', error);
        }
    }

    return (
        <Box
            component="form"
            sx={{
                '& .MuiTextField-root': { m: 1, width: '25ch' },
            }}
            noValidate
            autoComplete="off"
            onSubmit={handleSubmit}
        >
            <Grid container spacing={2}>
                <Grid item xs={6} md={12} lg={6}>
                    <TextField
                        //fullWidth
                        label="First name"
                        //helperText="Incorrect entry."
                        variant="standard"
                        name="firstName"
                        onChange={handleChange}
                        value={author.firstName}
                    />
                </Grid>
                <Grid item xs={6} md={12} lg={6}>
                    <TextField
                        label="Last name"
                        //helperText="Incorrect entry."
                        variant="standard"
                        name="lastName"
                        onChange={handleChange}
                        value={author.lastName}
                    />
                </Grid>
                <Grid item xs={6} md={12} lg={6}>
                    <TextField
                        label="Birthday"
                        //helperText="Incorrect entry."
                        variant="standard"
                        name="birthday"
                        onChange={handleChange}
                        value={author.birthday}
                    />
                </Grid>
                <Grid item xs={6} md={12} lg={6}>
                    <FormControl>
                        <FormLabel id="demo-controlled-radio-buttons-group">Gender</FormLabel>
                        <RadioGroup
                            row
                            aria-labelledby="demo-controlled-radio-buttons-group"
                            name="gender"
                            onChange={handleChange}
                        >
                            <FormControlLabel value="female" control={<Radio/>} label="Female"/>
                            <FormControlLabel value="male" control={<Radio/>} label="Male"/>
                            <FormControlLabel value="other" control={<Radio/>} label="Other"/>
                        </RadioGroup>
                    </FormControl>
                </Grid>
                <Grid item xs={6} md={12} lg={6}>
                    <LoadingButton
                        type="submit"
                        loadingPosition="start"
                        startIcon={<SaveIcon/>}
                        variant="outlined"
                    >
                        Save
                    </LoadingButton>
                </Grid>
            </Grid>
        </Box>
    );
}