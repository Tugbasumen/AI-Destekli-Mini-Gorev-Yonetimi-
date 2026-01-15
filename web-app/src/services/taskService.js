import { initialTasks } from "../data/tasks.mock";

let tasks = [...initialTasks];

export const getTasks = async () => {
  return tasks;
};

