import { Test } from "@nestjs/testing";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
describe("AppController", () => {
    let appController;
    beforeEach(async () => {
        const module = await Test.createTestingModule({
            controllers: [AppController],
            providers: [AppService],
        }).compile();
        appController = module.get(AppController);
    });
    it('should return "Hello, NestJS World!"', () => {
        expect(appController.getHello()).toBe("Hello, NestJS World!");
    });
});
