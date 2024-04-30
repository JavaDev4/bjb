import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
public class IsbDDAApiServiceTest {

    @Mock
    private RestTemplate isbRestTemplate;

    @InjectMocks
    private IsbDDAApiService service;

    @Value("${isb-dda.serviceUrl}")
    private String ddaURL;

    @Value("${isb-dda.authToken}")
    private String token;

    @Test
    void whenFetchIsbDDAResponseIsCalledAndClientReturnsOk_thenResponseIsReturned() {
        // Arrange
        String ddaNumber = "12345";
        IsbDDAApiService mockResponse = new IsbDDAApiService(); // Replace with your actual response type
        ResponseEntity<IsbDDAApiService> responseEntity = new ResponseEntity<>(mockResponse, HttpStatus.OK);

        when(isbRestTemplate.exchange(
                anyString(),
                eq(HttpMethod.GET),
                any(HttpEntity.class),
                eq(IsbDDAApiService.class)))
                .thenReturn(responseEntity);

        // Act
        IsbDDAApiService result = service.fetchIsbDDAResponse(ddaNumber);

        // Assert
        assertNotNull(result);
        assertEquals(mockResponse, result);
    }

    @Test
    void whenFetchIsbDDAResponseIsCalledAndClientThrowsException_thenNullIsReturned() {
        // Arrange
        String ddaNumber = "12345";
        when(isbRestTemplate.exchange(
                anyString(),
                eq(HttpMethod.GET),
                any(HttpEntity.class),
                eq(IsbDDAApiService.class)))
                .thenThrow(new RuntimeException("Client Error"));

        // Act and Assert
        Exception exception = assertThrows(RuntimeException.class, () -> {
            service.fetchIsbDDAResponse(ddaNumber);
        });

        assertEquals("Client Error", exception.getMessage());
    }
}