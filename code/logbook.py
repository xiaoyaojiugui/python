# !/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@Author   : jason.zhuo
@Filename : logbook.py
@Version  : V1.0.0
@Date     : 2019-05-14 19:29:07
@Desc     : 文件描述
"""

from logbook import Logger, StreamHandler
import sys

log = Logger('Logbook')
StreamHandler(sys.stdout).push_application()
log.info("logbook test")


def funcname(a, b, c):
    """
     * @param Object {ddd}
     * @return  {*}
     */
    """
    pass
