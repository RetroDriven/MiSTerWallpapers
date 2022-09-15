import subprocess
import urllib.request
import shutil
import os
import sys

def main():
    print('Building database...')

    dryrun = False
    if len(sys.argv) >= 2 and sys.argv[1] == '-d':
        print('Dry run')
        dryrun = True

    if not dryrun:
        subprocess.run(['git', 'config', '--global', 'user.email', 'theypsilon@gmail.com'], check=True)
        subprocess.run(['git', 'config', '--global', 'user.name', 'The CI/CD Bot'], check=True)

    urllib.request.urlretrieve('https://raw.githubusercontent.com/MiSTer-devel/Distribution_MiSTer/develop/.github/calculate_db.py', '/tmp/distribution_calculate_db.py')

    db_id = os.getenv('GITHUB_REPOSITORY', 'theypsilon/test')
    db_url = f'https://raw.githubusercontent.com/{db_id}/db/db.json.zip'
    base_files_url = f'https://raw.githubusercontent.com/{db_id}/%s/'

    calculate_env = {
        'DB_ID': db_id,
        'DB_URL': db_url,
        'DB_ZIP_NAME': 'db.json.zip',
        'DB_JSON_NAME': 'db.json',
        'BASE_FILES_URL': base_files_url,
        'LATEST_ZIP_URL': '',
        'CHECK_CHANGED': 'false'
    }

    print('Calculating database with environment:')
    print(calculate_env)

    result = subprocess.run(['python3', '/tmp/distribution_calculate_db.py', '-d'], env=calculate_env)
    if result.returncode != 0:
        print('Error: Failed to build database')
        return 1

    if not dryrun:
        print('Pushing database...')
        subprocess.run(['git', 'checkout', '--orphan','db'], check=True)
        subprocess.run(['git', 'reset'], check=True)
        subprocess.run(['git', 'add', 'db.json.zip'], check=True)
        subprocess.run(['git', 'commit', '-m','Creating database'], check=True)
        subprocess.run(['git', 'push', '--force','origin', 'db'], check=True)

    return 0

if __name__ == '__main__':
    exit(main())
