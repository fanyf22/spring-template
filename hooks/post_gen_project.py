import os


def delete_gitkeep_files():
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file == '.gitkeep':
                path = os.path.join(root, file)
                os.remove(path)
                print(f'Removed: {path}')


if __name__ == '__main__':
    print('Deleting .gitkeep files...')
    delete_gitkeep_files()
