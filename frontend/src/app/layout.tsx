import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import {StyledEngineProvider, Toolbar} from "@mui/material";
import Container from "@mui/material/Container";
import Typography from "@mui/material/Typography";
import CssBaseline from "@mui/material/CssBaseline";
import Box from "@mui/material/Box";
import {createTheme, ThemeProvider} from "@mui/material/styles";
import ResponsiveAppBar from "@/components/ResponsiveAppBar";
import Copyright from "@/components/Copyright";
import {AppRouterCacheProvider} from "@mui/material-nextjs/v13-appRouter";
import theme from "@/theme";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Create Next App",
  description: "Generated by create next app",
};

export default function RootLayout({children,}: Readonly<{ children: React.ReactNode; }>) {
  return (
    <html lang="en">
      <body className={inter.className}>
      <AppRouterCacheProvider
          //options={{ enableCssLayer: true }}
      >
          <ThemeProvider theme={theme}>
              <Box
                  sx={{
                      display: 'flex',
                      flexDirection: 'column',
                      minHeight: '100vh',
                  }}
              >
                  <CssBaseline />
                  <ResponsiveAppBar />
                  <Box
                      component="main"
                      sx={{
                          flexGrow: 1,
                          overflow: 'auto',
                      }}
                  >
                      <Toolbar />
                      <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
                          {children}
                      </Container>
                  </Box>

                  <Box
                      component="footer"
                      sx={{
                          py: 3,
                          px: 2,
                          mt: 'auto',
                      }}
                  >
                      <Container maxWidth="sm">
                          <Typography variant="body1">
                              My sticky footer can be found here.
                          </Typography>
                          <Copyright />
                      </Container>
                  </Box>
              </Box>
          </ThemeProvider>
      </AppRouterCacheProvider>
      </body>
    </html>
  );
}