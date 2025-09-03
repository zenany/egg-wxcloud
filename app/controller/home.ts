import { Controller } from 'egg';

class HomeController extends Controller {
  async index() {
    const { ctx } = this;
    ctx.body = 'hello world~';
  }
}

export default HomeController;