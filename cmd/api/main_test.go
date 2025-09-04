package main

import (
	"io"
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestHelloWorldHandler_Integration(t *testing.T) {
	go func() {
		if err := run(); err != nil && err != http.ErrServerClosed {
			t.Logf("Error starting server for test: %v", err)
		}
	}()

	client := &http.Client{}
	req, err := http.NewRequest(http.MethodGet, "http://localhost:8080/", nil)
	require.NoError(t, err, "Should be able to create a new request")

	resp, err := client.Do(req)
	require.NoError(t, err, "Should be able to perform the HTTP request")
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	require.NoError(t, err, "Should be able to read the response body")

	assert.Equal(t, http.StatusOK, resp.StatusCode, "Status code should be 200 OK")
	assert.Equal(t, "Hello, World from Docker Debug!", string(body), "Response body should match the expected message")
}
