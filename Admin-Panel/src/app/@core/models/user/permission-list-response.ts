import { Permission } from "./permission";
import { BaseListResponse } from "../base-list.response";

export class PermissionListResponse extends BaseListResponse{
    data: Array<Permission>;
}