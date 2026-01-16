import Header from "./components/Header";
import TaskList from "./components/TaskList";
import { useTasks } from "./hooks/useTasks";
import theme from "./theme/theme";

import {
  Container,
  CircularProgress,
  Box,
} from "@mui/material";

import { ThemeProvider } from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";

function App() {
  const { tasks, loading } = useTasks();

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />

      <Header />

      <Container maxWidth="sm" sx={{ mt: 3 }}>
        {loading ? (
          <Box display="flex" justifyContent="center" mt={4}>
            <CircularProgress />
          </Box>
        ) : (
          <TaskList tasks={tasks} />
        )}
      </Container>
    </ThemeProvider>
  );
}

export default App;
