"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g = Object.create((typeof Iterator === "function" ? Iterator : Object).prototype);
    return g.next = verb(0), g["throw"] = verb(1), g["return"] = verb(2), typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
Object.defineProperty(exports, "__esModule", { value: true });
var client_1 = require("@prisma/client");
var prisma = new client_1.PrismaClient();
function addPermissions() {
    return __awaiter(this, void 0, void 0, function () {
        var permissions, _i, permissions_1, permission, error_1, admin, allPermissions, _a, allPermissions_1, permission, error_2;
        return __generator(this, function (_b) {
            switch (_b.label) {
                case 0:
                    permissions = [
                        {
                            id: 'inicio',
                            name: 'inicio',
                            description: 'Acceso a la página de inicio'
                        },
                        {
                            id: 'pacientes',
                            name: 'pacientes',
                            description: 'Gestión de pacientes'
                        },
                        {
                            id: 'citas',
                            name: 'citas',
                            description: 'Gestión de citas'
                        },
                        {
                            id: 'pagos',
                            name: 'pagos',
                            description: 'Gestión de pagos'
                        },
                        {
                            id: 'consentimientos',
                            name: 'consentimientos',
                            description: 'Gestión de consentimientos'
                        },
                        {
                            id: 'servicios',
                            name: 'servicios',
                            description: 'Gestión de servicios'
                        },
                        {
                            id: 'reportes',
                            name: 'reportes',
                            description: 'Acceso a reportes'
                        },
                        {
                            id: 'comunicacion',
                            name: 'comunicacion',
                            description: 'Gestión de comunicación'
                        },
                        {
                            id: 'portal_paciente',
                            name: 'portal_paciente',
                            description: 'Acceso al portal de pacientes'
                        },
                        {
                            id: 'pagos_odontologos',
                            name: 'pagos_odontologos',
                            description: 'Gestión de pagos a odontólogos'
                        },
                        {
                            id: 'configuracion',
                            name: 'configuracion',
                            description: 'Acceso a la configuración'
                        }
                    ];
                    _i = 0, permissions_1 = permissions;
                    _b.label = 1;
                case 1:
                    if (!(_i < permissions_1.length)) return [3 /*break*/, 6];
                    permission = permissions_1[_i];
                    _b.label = 2;
                case 2:
                    _b.trys.push([2, 4, , 5]);
                    return [4 /*yield*/, prisma.permission.upsert({
                            where: { id: permission.id },
                            update: {},
                            create: permission
                        })];
                case 3:
                    _b.sent();
                    console.log("Permiso ".concat(permission.name, " agregado/actualizado"));
                    return [3 /*break*/, 5];
                case 4:
                    error_1 = _b.sent();
                    console.error("Error al agregar permiso ".concat(permission.name, ":"), error_1);
                    return [3 /*break*/, 5];
                case 5:
                    _i++;
                    return [3 /*break*/, 1];
                case 6: return [4 /*yield*/, prisma.user.findFirst({
                        where: { role: 'ADMIN' }
                    })];
                case 7:
                    admin = _b.sent();
                    if (!admin) return [3 /*break*/, 14];
                    return [4 /*yield*/, prisma.permission.findMany()];
                case 8:
                    allPermissions = _b.sent();
                    _a = 0, allPermissions_1 = allPermissions;
                    _b.label = 9;
                case 9:
                    if (!(_a < allPermissions_1.length)) return [3 /*break*/, 14];
                    permission = allPermissions_1[_a];
                    _b.label = 10;
                case 10:
                    _b.trys.push([10, 12, , 13]);
                    return [4 /*yield*/, prisma.userPermission.upsert({
                            where: {
                                userId_permissionId: {
                                    userId: admin.id,
                                    permissionId: permission.id
                                }
                            },
                            update: {},
                            create: {
                                userId: admin.id,
                                permissionId: permission.id
                            }
                        })];
                case 11:
                    _b.sent();
                    console.log("Permiso ".concat(permission.name, " asignado al admin"));
                    return [3 /*break*/, 13];
                case 12:
                    error_2 = _b.sent();
                    console.error("Error al asignar permiso ".concat(permission.name, " al admin:"), error_2);
                    return [3 /*break*/, 13];
                case 13:
                    _a++;
                    return [3 /*break*/, 9];
                case 14: return [4 /*yield*/, prisma.$disconnect()];
                case 15:
                    _b.sent();
                    return [2 /*return*/];
            }
        });
    });
}
addPermissions()
    .catch(console.error)
    .finally(function () { return process.exit(0); });
