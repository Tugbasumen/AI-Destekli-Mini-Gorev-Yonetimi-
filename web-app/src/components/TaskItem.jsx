import { Card, CardContent, Typography, Chip, Box } from "@mui/material";
import { TaskCategoryConfig } from "../data/taskCategories";
import PersonIcon from "@mui/icons-material/Person";
import WorkIcon from "@mui/icons-material/Work";
import SchoolIcon from "@mui/icons-material/School";
import FavoriteIcon from "@mui/icons-material/Favorite";

const TaskCategoryIcons = {
  kisisel: PersonIcon,
  isler: WorkIcon,
  egitim: SchoolIcon,
  saglik: FavoriteIcon,
};

function TaskItem({ task }) {
  const categoryConfig = TaskCategoryConfig[task.category];
  const CategoryIcon = TaskCategoryIcons[task.category];

  return (
    <Card
      elevation={3}
      sx={{
        mb: 2,
        borderLeft: `6px solid ${categoryConfig.color}`,
        "&:hover": { boxShadow: 6 },
      }}
    >
      <CardContent>
        <Typography variant="h6" fontWeight={600} display="flex" alignItems="center" gap={1}>
          <CategoryIcon sx={{ color: categoryConfig.color }} />
          {task.title}
        </Typography>
      </CardContent>
    </Card>
  );
}

export default TaskItem;
