import { List, Paper, Typography, Box, Divider } from "@mui/material";
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
      elevation={2}
      sx={{
        mt: 3,
        borderRadius: 2,
        overflow: "hidden",
      }}
    >
      {/* Header */}
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

      {/* Task List */}
      <List disablePadding sx={{ p: 2 }}>
        {tasks.map((task, index) => (
          <Box key={task.id}>
            <TaskItem task={task} />
            {index !== tasks.length - 1 && (
              <Divider sx={{ my: 1 }} />
            )}
          </Box>
        ))}
      </List>
    </Paper>
  );
}

export default TaskList;
