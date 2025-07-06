#!/usr/bin/env python3
"""
Utility script to generate secure secret keys for FastAPI applications.
"""

import secrets
import argparse

def generate_secret_key(length: int = 32) -> str:
    """Generate a secure secret key using secrets module."""
    return secrets.token_urlsafe(length)

def main():
    parser = argparse.ArgumentParser(description="Generate FastAPI secret keys")
    parser.add_argument(
        "--length", 
        type=int, 
        default=32, 
        help="Length of the secret key (default: 32)"
    )
    parser.add_argument(
        "--format", 
        choices=["plain", "env", "python"], 
        default="plain",
        help="Output format (default: plain)"
    )
    
    args = parser.parse_args()
    
    secret_key = generate_secret_key(args.length)
    
    if args.format == "env":
        print(f"SECRET_KEY={secret_key}")
    elif args.format == "python":
        print(f'SECRET_KEY = "{secret_key}"')
    else:
        print(f"Generated FastAPI Secret Key:")
        print(secret_key)
        print(f"\nLength: {len(secret_key)} characters")
        print(f"Entropy: {args.length * 8} bits")

if __name__ == "__main__":
    main() 