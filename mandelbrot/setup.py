from setuptools import setup


def readme():
    with open('README.rst') as f:
        return f.read()


setup(name='funniest',
      version='0.1',
      install_requires=[
          'markdown',
      ],
      test_suite='nose.collector',
      tests_require=['nose', 'nose-cover3'],
      entry_points={
          'console_scripts': ['funniest-joke=funniest.command_line:main'],
      },
      include_package_data=True,
      zip_safe=False)