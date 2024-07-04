# app_python

## Initialization

```bash
python -m venv venv
source venv/bin/activate
pip install flask
pip install gunicorn
pip install pytest
pip freeze > requirements.txt
```

## Development

```bash
git clone <REPO_URL>
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Autotests

- The repository contains a `.github/workflows` directory with an action to automatically run `pytest` on the source code on each push to GitHub.
- A similar pipeline `.gitlab-ci.yml` is located in repository root to do the same in GitLab.
