export class CategoryEntity implements IEntity {
    id: number;
    name: string;
    icon: string;
  }

  export interface IEntity {
    id: number;
  }