"""
MCP Server for Unreal Engine Blueprint Analysis
================================================
This is a demonstration of MCP (Model Context Protocol) server implementation
that connects AI tools (Claude Code, Cursor, etc.) to Unreal Engine Editor.

Key Components:
- MCP Server setup with @app decorators
- Tool definitions with JSON schemas
- Unreal Engine connection via Python Remote Execution
"""

import asyncio
import json
import logging
from typing import Any

from mcp.server import Server
from mcp.types import Resource, Tool, TextContent
from pydantic import AnyUrl

from .unreal_connection import UnrealEngineConnection

logger = logging.getLogger(__name__)

# Initialize MCP server
app = Server("bpaibridge")

# Unreal Engine connection instance
unreal_connection: UnrealEngineConnection | None = None


# =============================================================================
# MCP Resources - Expose Unreal assets as readable resources
# =============================================================================

@app.list_resources()
async def list_resources() -> list[Resource]:
    """List available Unreal Engine resources (Blueprints, Materials)."""
    resources = []

    if not unreal_connection or not unreal_connection.is_connected():
        return resources

    # List all blueprints from Unreal Engine
    result = await unreal_connection.execute_python(
        "print(unreal.BPAIBridgeMCPAdapter.mcp_list_all_blueprints())"
    )
    if result:
        # ... parse JSON and create Resource objects
        pass

    return resources


@app.read_resource()
async def read_resource(uri: AnyUrl) -> str:
    """Read Blueprint or Material content by URI."""
    uri_str = str(uri)

    if not unreal_connection or not unreal_connection.is_connected():
        raise RuntimeError("Not connected to Unreal Engine Editor")

    if uri_str.startswith("blueprint://"):
        asset_path = uri_str.replace("blueprint://", "")
        # ... execute Python command to read blueprint
        pass

    return json.dumps({"error": "Unsupported URI"})


# =============================================================================
# MCP Tools - Define available operations
# =============================================================================

@app.list_tools()
async def list_tools() -> list[Tool]:
    """List available tools for Blueprint operations."""
    return [
        # Tool 1: Connect to Unreal Engine
        Tool(
            name="connect_unreal",
            description="Connect to running Unreal Engine Editor via Python Remote Execution",
            inputSchema={
                "type": "object",
                "properties": {
                    "host": {
                        "type": "string",
                        "description": "Multicast bind address",
                        "default": "localhost",
                    },
                    "port": {
                        "type": "integer",
                        "description": "Multicast group port",
                        "default": 6766,
                    },
                },
                "required": [],
            },
        ),

        # Tool 2: List all Blueprints
        Tool(
            name="list_blueprints",
            description="List all Blueprint assets in the project",
            inputSchema={
                "type": "object",
                "properties": {},
            },
        ),

        # Tool 3: Read Blueprint nodes
        Tool(
            name="read_blueprint_nodes",
            description="Read all Blueprint graph nodes as human-readable text",
            inputSchema={
                "type": "object",
                "properties": {
                    "asset_path": {
                        "type": "string",
                        "description": "Blueprint asset path (e.g., /Game/Blueprints/BP_MyActor)",
                    },
                },
                "required": ["asset_path"],
            },
        ),

        # Tool 4: Execute arbitrary Python in Unreal
        Tool(
            name="execute_python",
            description="Execute Python code in Unreal Engine Editor",
            inputSchema={
                "type": "object",
                "properties": {
                    "code": {
                        "type": "string",
                        "description": "Python code to execute",
                    },
                },
                "required": ["code"],
            },
        ),

        # ... additional tools can be added here
    ]


# =============================================================================
# MCP Tool Handler - Process tool calls from AI
# =============================================================================

@app.call_tool()
async def call_tool(name: str, arguments: Any) -> list[TextContent]:
    """Handle tool calls from MCP client."""
    global unreal_connection

    try:
        # --- connect_unreal ---
        if name == "connect_unreal":
            host = arguments.get("host", "localhost")
            port = arguments.get("port", 6766)

            unreal_connection = UnrealEngineConnection(host, port)
            success = await unreal_connection.connect()

            if success:
                return [TextContent(type="text", text=f"Connected to Unreal Engine at {host}:{port}")]
            else:
                return [TextContent(type="text", text=f"Failed to connect")]

        # Check connection for other tools
        if not unreal_connection or not unreal_connection.is_connected():
            return [TextContent(type="text", text="Error: Not connected. Use 'connect_unreal' first.")]

        # --- list_blueprints ---
        if name == "list_blueprints":
            command = "print(unreal.BPAIBridgeMCPAdapter.mcp_list_all_blueprints())"
            result = await unreal_connection.execute_python(command)
            # ... parse and format result
            return [TextContent(type="text", text=result or "No blueprints found")]

        # --- read_blueprint_nodes ---
        elif name == "read_blueprint_nodes":
            asset_path = arguments["asset_path"]
            command = f"print(unreal.BPAIBridgeMCPAdapter.mcp_bp_graph_get_as_text('{asset_path}'))"
            result = await unreal_connection.execute_python(command)
            return [TextContent(type="text", text=result or "Failed to read blueprint")]

        # --- execute_python ---
        elif name == "execute_python":
            code = arguments["code"]
            result = await unreal_connection.execute_python(code)
            return [TextContent(type="text", text=result or "Executed (no output)")]

        else:
            return [TextContent(type="text", text=f"Unknown tool: {name}")]

    except Exception as e:
        logger.error(f"Error in call_tool: {e}", exc_info=True)
        return [TextContent(type="text", text=f"Error: {str(e)}")]


# =============================================================================
# Entry Point
# =============================================================================

async def main():
    """Main entry point for the MCP server."""
    from mcp.server.stdio import stdio_server

    async with stdio_server() as (read_stream, write_stream):
        await app.run(
            read_stream,
            write_stream,
            app.create_initialization_options(),
        )


if __name__ == "__main__":
    asyncio.run(main())
