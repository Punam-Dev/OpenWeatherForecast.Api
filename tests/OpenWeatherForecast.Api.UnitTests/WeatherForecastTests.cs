using FluentAssertions;
using OpenWeatherForecast.Api.UnitTests.Abstractions;
using System.Net;

namespace OpenWeatherForecast.Api.UnitTests;

public class WeatherForecastTests : BaseIntegrationTest
{
    public WeatherForecastTests(IntegrationTestWebApplicationFactory factory) : base(factory)
    {
    }

    [Fact]
    public async Task WeatherForecast_ShouldReturnSuccess()
    {
        // Act
        var response = await HttpClient.GetAsync("weatherforecast");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);
    }
}
