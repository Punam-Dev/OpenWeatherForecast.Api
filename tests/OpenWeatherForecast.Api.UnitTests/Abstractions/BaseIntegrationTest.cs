namespace OpenWeatherForecast.Api.UnitTests.Abstractions;

public abstract class BaseIntegrationTest : IClassFixture<IntegrationTestWebApplicationFactory>
{
    protected HttpClient HttpClient { get; }
    protected BaseIntegrationTest(IntegrationTestWebApplicationFactory factory)
    {
        HttpClient = factory.CreateClient();
    }
}
