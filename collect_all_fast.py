#!/usr/bin/env python3
import time
import subprocess
import time
import sys

# ==========================
# Configuration
# ==========================
MAX_RETRIES = 2      # Number of retries per command
RETRY_DELAY = 30     # Seconds between retries
TIMEOUT = 60*30  # 30min per attempt

COMMANDS = [
    # "earthly +collect-data"
    "earthly +systems"
]
successful = {}
failed = {}


def run_command(command):
    """
    Run a command and return True if successful.
    """
    try:
        result = subprocess.run(
            command,
            shell=True,
            check=False,
            timeout=TIMEOUT   
        )
        return result.returncode == 0

    except subprocess.TimeoutExpired:
        print(f"\nTIMEOUT ERROR:")
        print(f"Command took longer than {TIMEOUT/60:.0f} minutes and was killed:")
        print(f"  {command}")
        return False

    except Exception as e:
        print(f"Exception while running command: {e}")
        return False
    

def main():
    total_commands = len(COMMANDS)

    for idx, command in enumerate(COMMANDS, start=1):

        print("\n" + "=" * 80)
        print(f"[{idx}/{total_commands}] Running: {command}")
        print("=" * 80)

        success = False
        command_start = time.time()

        for attempt in range(1, MAX_RETRIES + 1):

            print(f"\nAttempt {attempt}/{MAX_RETRIES}")

            if run_command(command):
                print(f"SUCCESS: {command}")
                success = True
                break

            print(f"FAILED: {command}")

            if attempt < MAX_RETRIES:
                print(f"Waiting {RETRY_DELAY} seconds before retry...")
                time.sleep(RETRY_DELAY)

        elapsed = time.time() - command_start

        if success:
            successful[command] = {
                "attempts": attempt,
                "time": elapsed
            }
        else:
            failed[command] = {
                "attempts": MAX_RETRIES,
                "time": elapsed
            }

            print("\n" + "!" * 80)
            print(f"ERROR: Command failed after {MAX_RETRIES} attempts:")
            print(command)
            print("Continuing to next command...")
            print("!" * 80)

    print("\n" + "=" * 80)
    print("ALL COMMANDS COMPLETED SUCCESSFULLY")
    print("=" * 80)


if __name__ == "__main__":
    main()
    
    
    print("\n" + "=" * 80)
    print("SUMMARY")
    print("=" * 80)

    print(f"\nSuccessful ({len(successful)}):")

    for cmd, info in successful.items():
        print(
            f"  ✓ {cmd:<25} "
            f"Attempts: {info['attempts']:<2} "
            f"Time: {info['time']:.1f}s"
        )

    print(f"\nFailed ({len(failed)}):")

    for cmd, info in failed.items():
        print(
            f"  ✗ {cmd:<25} "
            f"Attempts: {info['attempts']:<2} "
            f"Time: {info['time']:.1f}s"
        )

    print("\n" + "=" * 80)

    total_time = (
        sum(info["time"] for info in successful.values()) +
        sum(info["time"] for info in failed.values())
    )

    print(f"Total elapsed time: {total_time:.1f} seconds")
    print(f"Total elapsed time: {total_time/60:.1f} minutes")

    print("=" * 80)
