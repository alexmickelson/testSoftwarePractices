using System;
using StackExchange.Redis;

public class RedisCache
{
    private readonly ConnectionMultiplexer _connection;
    private readonly IDatabase _db;

    public RedisCache(string connectionString)
    {
        _connection = ConnectionMultiplexer.Connect(connectionString);
        _db = _connection.GetDatabase();
    }

    public void Set(string key, string value, TimeSpan? expiresIn = null)
    {
        _db.StringSet(key, value, expiresIn);
    }

    public string Get(string key)
    {
        return _db.StringGet(key);
    }
}