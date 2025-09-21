from beet import Context, Function

def function_headers(ctx: Context):
  for name, func in ctx.data.functions.items():
    func.lines.insert(0, f"# {name}")
