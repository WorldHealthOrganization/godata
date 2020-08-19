
const TOKEN_SAFE_THRESHOLD = 10

async function autoLogin (next, ctx, _ = {}) {
  const token = ctx.config.token
  if (token != null && (Date.now() - token.lastRefresh) / 1000 + TOKEN_SAFE_THRESHOLD < token.ttl) {
    ctx.config.query.access_token = token.value
    return next(null, ctx)
  } else {
    try {
      const res = await ctx.config.api.login()
      ctx.config.token = {
        value: res.id,
        ttl: res.ttl,
        lastRefresh: _.date || Date.now()
      }
      ctx.config.query.access_token = res.id
      return next(null, ctx)
    } catch (err) {
      return next(err)
    }
  }
}

module.exports = { autoLogin, TOKEN_SAFE_THRESHOLD }

