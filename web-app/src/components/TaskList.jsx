import { List, Paper, Typography, Box } from "@mui/material";
import TaskItem from "./TaskItem";

function TaskList({ tasks }) {
  if (!tasks.length) {
    return (
      <Typography
        variant="body2"
        color="text.secondary"
        align="center"
        sx={{ mt: 4 }}
      >
        Henüz görev eklenmemiş.
      </Typography>
    );
  }

  return (
    <Paper
      elevation={3}
      sx={{
        mt: 3,
        borderRadius: 2,
        overflow: "hidden",
      }}
    >
      <Box
        sx={{
          px: 3,
          py: 2,
          backgroundColor: "primary.main",
        }}
      >
        <Typography
          variant="subtitle1"
          fontWeight={600}
          color="common.white"
        >
          Görev Listesi
        </Typography>
      </Box>

      <List disablePadding>
  {tasks.map((task, index) => (
    <Box key={task.id} sx={{ mb: index !== tasks.length - 1 ? 2 : 0 }}>
      <TaskItem task={task} />
    </Box>
  ))}
</List>

    </Paper>
  );
}

export default TaskList;
