import { useEffect, useState } from "react";
import { getTasks } from "./services/taskService";
import TaskList from "./components/TaskList";

import {
  Container,
  Typography,
  CircularProgress,
  Box,
} from "@mui/material";

import { ThemeProvider, createTheme } from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";

const theme = createTheme({
  palette: {
    primary: {
      main: "#1976d2",
    },
  },
});

function App() {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTasks = async () => {
      const data = await getTasks();
      setTasks(data);
      setLoading(false);
    };

    fetchTasks();
  }, []);

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />

      <Container maxWidth="sm">
        <Typography
          variant="h4"
          component="h1"
          align="center"
          gutterBottom
          sx={{ mt: 4 }}
        >
          Task Manager
        </Typography>

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
