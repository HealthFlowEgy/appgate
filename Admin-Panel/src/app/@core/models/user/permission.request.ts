export class PermissionRequest {
    role: string;
    new_role: string;
    permissions: Array<string>;
    meta: any = {project_id: null};
}
