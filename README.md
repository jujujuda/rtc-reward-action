# rtc-reward-action

> GitHub Action to automatically award RTC tokens when a Pull Request is merged.

## How It Works

When a PR is merged, this action transfers RTC from a project fund wallet to the PR author's wallet via the RustChain `/wallet/transfer` API.

## Usage

### Add to Your Repository

Create `.github/workflows/rtc-reward.yml`:

```yaml
name: RTC Reward

on:
  pull_request:
    types: [closed]

jobs:
  reward:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Award RTC for merged PR
        uses: jujujuda/rtc-reward-action@v1
        with:
          node-url: https://50.28.86.131
          amount: 5
          wallet-from: your-project-fund
          admin-key: ${{ secrets.RTC_ADMIN_KEY }}
          recipient: ${{ github.event.pull_request.user.login }}
          memo: "PR merged — RTC reward"
```

### Setup Secrets

In your repository, go to **Settings → Secrets and variables → Actions** and add:

| Secret | Description |
|--------|-------------|
| `RTC_ADMIN_KEY` | Admin key for the sender wallet (from RustChain node) |

### Configuration Options

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `node-url` | Yes | `https://50.28.86.131` | RustChain node URL |
| `amount` | Yes | — | RTC amount to award per merge |
| `wallet-from` | Yes | — | Sender wallet name (miner_id) |
| `admin-key` | Yes | — | Admin key for transfers |
| `recipient` | No | PR author | Recipient wallet name |
| `memo` | No | `PR merged — RTC reward` | Transfer memo |

### Example: Different Amounts Per PR Label

```yaml
jobs:
  reward:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Set reward amount
        id: amount
        run: |
          if [[ "${{ contains(github.event.pull_request.labels.*.name, 'major') }}" == "true" ]]; then
            echo "amount=20" >> $GITHUB_OUTPUT
          else
            echo "amount=5" >> $GITHUB_OUTPUT
          fi
      - uses: jujujuda/rtc-reward-action@v1
        with:
          node-url: https://50.28.86.131
          amount: ${{ steps.amount.outputs.amount }}
          wallet-from: ${{ secrets.RTC_WALLET }}
          admin-key: ${{ secrets.RTC_ADMIN_KEY }}
```

## Development

### Run Tests

```bash
pip install requests
python src/reward.py --help
```

### Build Docker Image

```bash
docker build -t rtc-reward-action .
```

## API Reference

This action calls the RustChain `/wallet/transfer` endpoint:

```json
POST /wallet/transfer
{
  "from_wallet": "project-fund",
  "to_wallet": "contributor-name",
  "amount": 5,
  "admin_key": "...",
  "memo": "PR merged — RTC reward"
}
```

## License

MIT
