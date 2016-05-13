#!/usr/bin/python
# fcr.py v2.1
import sys, os, glob
import csv, datetime, time
import math
import numpy as np
import numpy.linalg as la
import numpy.polynomial as pol
import numpy.random as rnd
import scipy.optimize as opt
import scipy.stats as stats
import scipy.interpolate as ipl
import matplotlib.pyplot as plt
import matplotlib.transforms as trans
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm

time_unit = 86400.0

done = 0

# -----------------------------------------------------------------------------
def model(p, X, Y, Z):
  global done
# p0 = [ 8.0e-6, 8.0e-6, 1.0, 1.5, 0.005, 24.0 ]
# print 'p(in) =', p

  a, b, c, d, e, o = p

# print 'p.shape = ', p.shape
# print 'X.shape = ', X.shape
# print 'Y.shape = ', Y.shape
# print 'Z.shape = ', Z.shape

  F1 = a*Y*pow(X - o, 2) + b*X
  lv = e*Y + 1.0
  if np.all(lv > 0):
    F2 = c + d*np.log(lv)
  else:
    F2 = c + 1e-10*Y
  Fxy = F1 + F2
# print 'F1 =', F1
# print 'F2 =', F2
# print 'Fxy =', Fxy

  if (done % 1000) == 0:
    print 'done =', done
    csvwrite('chk-%04d-F1.csv' % done, F1)
    csvwrite('chk-%04d-F2.csv' % done, F2)
    csvwrite('chk-%04d-Fxy.csv' % done, Fxy)
  done += 1

# print 'Z =', Z

# Diff = Z - Fxy
  Diffp = []
  lenXY = len(Fxy)
  for x in range(lenXY):
    Diffp.append([])
    for y in range(lenXY):
      z = Z.item((x, y))
      fxy = Fxy.item((x, y))
      if z <> 0.0:
        d = z - fxy
      else:
        d = 0.0
      Diffp[x].append(d)
  Diff = np.array(Diffp).astype(np.float_)
# print 'Diff =', Diff

  dsum = 0.0
  for d in np.nditer(Diff):
    dsum += pow(d, 2)
  print 'dsum =', dsum

  return dsum

# -----------------------------------------------------------------------------
def polyfit2d(x, y, f, deg):
  x = np.asarray(x)
  print 'pf2:x.shape =', x.shape
# print 'pf2:x =', x
  y = np.asarray(y)
  print 'pf2:y.shape =', y.shape
# print 'pf2:y =', y
  f = np.asarray(f)
  print 'pf2:f.shape =', f.shape
# print 'pf2:f =', f
  deg = np.asarray(deg)
  print 'pf2:deg =', deg

  vander = pol.polynomial.polyvander2d(x, y, deg)
  print 'pf2:vander.shape =', vander.shape
# print 'pf2:vander =', vander
  vander = vander.reshape((-1,vander.shape[-1]))
  print 'pf2:vander.rs.shape =', vander.shape
# print 'pf2:vander.rs =', vander

  f = f.reshape((vander.shape[0],))
  print 'pf2:f.rs.shape =', f.shape
# print 'pf2:f.rs =', f

  c = la.lstsq(vander, f)[0]
  print 'pf2:c.shape =', c.shape
# print 'pf2:c =', c
  c = c.reshape(deg+1)
  print 'pf2:c.rs.shape =', c.shape
  print 'pf2:c.rs =', c

  return c

# -----------------------------------------------------------------------------
def residuals(X, Y, Z, c):
  Zn = pol.polynomial.polygrid2d(X, Y, c)

  res = []
  res_med = 0.0
  res_max = -1

  lenX = len(X)
  lenY = len(Y)
  for x in range(lenX):
    for y in range(lenY):
      diff2 = pow(Z[x,y] - Zn[x,y], 2)
      if diff2 > res_max:
        res_max = diff2
      res.append(diff2)

  res = np.asarray(res)
  res_sum = np.sum(res)
  if len(res):
    res_med = np.median(res)

  print 'res_sum =', res_sum
  print 'res_med =', res_med
  print 'res_max =', res_max

  return (res_sum, res_med, res_max)

# -----------------------------------------------------------------------------
def optim(X, Y, Z):
# create meshgrid from X & Y
# XXp = [X.tolist() for x in range(lenXY)]
# YYp = [Y.tolist() for y in range(lenXY)]
# XX = np.array(XXp)
# YY = np.array(YYp).T
  mg = np.meshgrid(X, Y)
  XX = mg[0]
  YY = mg[1]
# print 'XX =', XX
# print 'YY =', YY

  best = [4,3]
  if False:
    # Find the best polynomial fit (degree)
    val_min = sys.maxsize
    for p in range(1,10):
      for q in range(1,10):
        sys.stderr.write('Fiting order [%d, %d]\n' % (p, q))
        c = polyfit2d(XX, YY, Z, [p,q])
      # csvwrite('fit2d_coef.csv', c)
        res_sum, res_med, res_max = residuals(X, Y, Z, c)
        val = res_sum * res_med * res_max
        if val < val_min:
          best = [p,q]
          sys.stderr.write('best sofar = [%d, %d]\n' % (p, q))
          print 'best sofar = [%d, %d]' % (p, q)
          val_min = val
    sys.stderr.write('final best = %s\n' % best)
    print 'final best =', best

  c = polyfit2d(XX, YY, Z, best)
# csvwrite('fit2d_coef.csv', c)

  res_sum, res_med, res_max = residuals(X, Y, Z, c)

  Zn = pol.polynomial.polygrid2d(X, Y, c)
  Zn = Zn.T # required by polygrid2d
  print 'Zn.shape =', Zn.shape
# print 'Zn =', Zn
  csvwritexy('fcr_model.csv', X, Y, Zn)

  # Plot FCR model
  fig = plt.figure()
  axs = Axes3D(fig)
  plt.title('Model FCR')
  axs.set_ylabel('Temp')
  axs.set_xlabel('Aver.wt.')
  axs.set_zlabel('FCR')
  plt.gca().invert_xaxis()
# axs.plot_wireframe(XX, YY, Zn.T, color='red')
  srf = axs.plot_surface(XX, YY, Zn.T, cmap=cm.rainbow, rstride=1, cstride=1)
  axs.scatter(XX, YY, Z.T)
  plt.colorbar(srf, shrink=0.6, aspect=15)
  plt.savefig('fcr_model.png')
  sys.stdout.flush()
  plt.show()

  p = (0, 0)
  return p

# -----------------------------------------------------------------------------
def delzerorow(X, Z):
  zerorow = []

  lenX = len(Z)
  lenY = len(Z[0])
  if lenX != len(X):
    sys.stderr.write('X(%d) and Zx(%d) not equal length\n' % (len(X), lenX))
    return (None, None)

# print 'lenX = %d, lenY = %d' % (lenX, lenY)
  for x in range(lenX):
    val = 0
    for y in range(lenY):
      val += Z[x,y]
    if val == 0:
      zerorow.append(x)
  print 'zerorow =', zerorow

  Xc = np.delete(X, zerorow, 0)
  Zc = np.delete(Z, zerorow, 0)

# print 'Xc.shape =', Xc.shape
# print 'Xc =', Xc
# print 'Zc.shape =', Zc.shape
# print 'Zc =', Zc

  return (Xc, Zc)

# -----------------------------------------------------------------------------
def delzerocol(Y, Z):
  zerocol = []

  lenX = len(Z)
  lenY = len(Z[0])
  if lenY != len(Y):
    sys.stderr.write('Y(%d) and Zy(%d) not equal length\n' % (len(Y), lenY))
    return (None, None)

# print 'lenX = %d, lenY = %d' % (lenX, lenY)
  for y in range(lenY):
    val = 0
    for x in range(lenX):
      val += Z[x,y]
    if val == 0:
      zerocol.append(y)
  print 'zerocol =', zerocol

  Yc = np.delete(Y, zerocol, 0)
  Zc = np.delete(Z, zerocol, 1)

# print 'Yc.shape =', Yc.shape
# print 'Yc =', Yc
# print 'Zc.shape =', Zc.shape
# print 'Zc =', Zc

  return (Yc, Zc)

# -----------------------------------------------------------------------------
def cleandata(X, Y, Z):
  Xc, Zc = delzerorow(X, Z)
  Yc, Zc = delzerocol(Y, Zc)

  Zc = Zc.T # required by interp2d
  f = ipl.interp2d(Xc, Yc, Zc, kind='linear') # don't use cubic (--> holes)

  lenXc = len(Xc) # rows
  lenYc = len(Yc) # columns
  if lenYc > lenXc:
    # calculate new (denser) Xcn with interpolation
    Xl = np.linspace(1, lenXc, lenXc)
    fx = ipl.interp1d(Xl, Xc, kind='linear')
    Xln = np.linspace(1, lenXc, lenYc)
    Xcn = fx(Xln)

  # fig = plt.figure()
  # plt.plot(Xl, Xc, color='blue')
  # plt.scatter(Xln, Xcn, color='red')
  # sys.stdout.flush()
  # plt.show()

  # Ycn = np.linspace(Yc[0], Yc[lenYc-1], lenYc)
    Ycn = Yc

    # interpolated new Z
    Zcn = f(Xcn, Ycn)
    Zcn = Zcn.T

  elif lenXc > lenYc:
  # Xcn = np.linspace(Xc[0], Xc[lenXc-1], lenXc)
    Xcn = Xc

    # calculate new (denser) Ycn with interpolation
    Yl = np.linspace(1, lenYc, lenYc)
    fy = ipl.interp1d(Yl, Yc, kind='cubic')
    Yln = np.linspace(1, lenYc, lenXc)
    Ycn = fy(Yln)

  # fig = plt.figure()
  # plt.plot(Yl, Yc, color='blue')
  # plt.scatter(Yln, Ycn, color='red')
  # sys.stdout.flush()
  # plt.show()

    # interpolated new Z
    Zcn = f(Xcn, Ycn)
    Zcn = Zcn.T

  else:
  # Xcn = np.linspace(Xc[0], Xc[lenXc-1], lenXc)
    Xcn = Xc
  # Ycn = np.linspace(Yc[0], Yc[lenYc-1], lenYc)
    Ycn = Yc

    Zcn = Zc.T

  print 'Xcn.shape =', Xcn.shape
# print 'Xcn =', Xcn
  print 'Ycn.shape =', Ycn.shape
# print 'Ycn =', Ycn
  print 'Zcn.shape =', Zcn.shape
# print 'Zcn =', Zcn

  return (Xcn, Ycn, Zcn)

# -----------------------------------------------------------------------------
def csvwrite(file, Z):
  try:
    csvfile = open(file, 'wb')
    csvwriter = csv.writer(csvfile, delimiter=';', quotechar='"')

    csvwriter.writerows(Z)

    csvfile.close()
  except:
    sys.stderr.write('%s\n' % sys.exc_info()[1])
    return None
  return Z

# -----------------------------------------------------------------------------
def csvwritexy(file, X, Y, Z):
  try:
    csvfile = open(file, 'wb')
    csvwriter = csv.writer(csvfile, delimiter=';', quotechar='"')

    lenX = len(X)
    lenY = len(Y)
    for x in range(lenX):
      row = []
      if x == 0:
        # write header row (columns from Y)
        row.append(0.0)
        for y in range(lenY):
          row.append(Y[y])
        csvwriter.writerow(row)
        row = []
      # append X[i]
      row.append(X[x])
      for y in range(lenY):
        row.append(Z[x,y])
      csvwriter.writerow(row)

    csvfile.close()
  except:
    sys.stderr.write('%s\n' % sys.exc_info()[1])
    return None
  return Z

# -----------------------------------------------------------------------------
def csvread(file):
  Zp = []
  last_row = []

  try:
    csvfile = open(file, 'rb')
    csvreader = csv.reader(csvfile, delimiter=';', quotechar='"')

    lines = 0
    for row in csvreader:
      lines += 1
      Zp.append(row)
      last_row = row

    csvfile.close()
  except:
    sys.stderr.write('%s\n' % sys.exc_info()[1])
    return None

  lenZp = len(Zp)
  if lenZp < 5: # ignore files with less than 5 lines
    sys.stderr.write('%s: file too short (%d line%s)' % (file, lenZy, '' if lenZy == 1 else 's'))
    return None

  # Remove empty cells
  for z in range(lenZp):
    Zp[z] = filter(None, Zp[z])

  # Extend Z matrix to max. size
  lenZx = len(Zp)
  lenZy = len(Zp[0])
  if lenZy > lenZx:
    # extend X rows
    dl = lenZy - lenZx
    zeros = [['0.0' for y in range(lenZy)] for x in range(dl)]
    Zp.extend(zeros)
#   lastz = [last_row for x in range(dl)]
#   Zp.extend(lastz)
  elif lenZx > lenZy:
    # extend Y columns
    dl = lenZx - lenZy
    for x in range(lenZx):
      for y in range(dl):
        Zp[x].append('0.0')

  Z = np.array(Zp).astype(np.float_)

  print 'Read Z.shape:', Z.shape
# print 'Read Z:', Z

  return Z

# -----------------------------------------------------------------------------
def csvreadxy(file):
#
#  o---> Y (columns)
#  |
#  v
#  X (rows)
#
  Xp = [] # rows
  Yp = [] # columns
  Zp = []
  last_row = []

  try:
    csvfile = open(file, 'rb')
    csvreader = csv.reader(csvfile, delimiter=';', quotechar='"')

    lines = 0
    for row in csvreader:
      lines += 1
      if lines == 1: # Line 1 (temp) --> Y
        Yp = row[1:]
        continue
      if len(row[0]) == 0: # ignore lines with no data
        continue
      Xp.append(row.pop(0)) # Column 1 (aver.wt.) --> X
      Zp.append(row) # Values (FCR) --> Z
      last_row = row

    csvfile.close()
  except:
    sys.stderr.write('%s\n' % sys.exc_info()[1])
    return (None, None, None)

  # Remove empty cells
  Yp = filter(None, Yp)
  lenZp = len(Zp)
  for z in range(lenZp):
    Zp[z] = filter(None, Zp[z])

# print 'Read Xp.shape:', np.asarray(Xp).shape
# print 'Read Xp:', Xp
# print 'Read Yp.shape:', np.asarray(Yp).shape
# print 'Read Yp:', Yp
# print 'Read Zp.shape:', np.asarray(Zp).shape
# print 'Read Zp:', Zp

  lenZx = len(Zp)
  if lenZx < 5: # ignore files with less than 5 lines
    sys.stderr.write('%s: file too short (%d line%s)\n' % (file, lenZy, '' if lenZy == 1 else 's'))
    return (None, None, None)

  # Extend X or Y vectors to max. size (shouldn't be zeros!)
  lenX = len(Xp)
  lenY = len(Yp)
  if lenY > lenX:
    # extend X vector (rows)
    dl = lenY - lenX
    lastX = float(Xp[lenX-1])
    for x in range(dl):
      Xp.append(lastX+float(x+1)/100.0) # ???
  elif lenX > lenY:
    # extend Y vector (columns)
    dl = lenX - lenY
    lastY = float(Yp[lenY-1])
    for y in range(dl):
      Yp.append(lastY+y+1) # ???

  # Extend Z matrix to max. size
  lenZx = len(Zp)
  lenZy = len(Zp[0])
  if lenZy > lenZx:
    # extend X rows
    dl = lenZy - lenZx
    zeros = [['0.0' for y in range(lenZy)] for x in range(dl)]
    Zp.extend(zeros)
#   lastz = [last_row for x in range(dl)]
#   Zp.extend(lastz)
  elif lenZx > lenZy:
    # extend Y columns
    dl = lenZx - lenZy
    for x in range(lenZx):
      for y in range(dl):
        Zp[x].append('0.0')

  X = np.array(Xp).astype(np.float_)
  Y = np.array(Yp).astype(np.float_)
  Z = np.array(Zp).astype(np.float_)

  print 'Extended X.shape:', X.shape
# print 'Extended X:', X
  print 'Extended Y.shape:', Y.shape
# print 'Extended Y:', Y
  print 'Extended Z.shape:', Z.shape
# print 'Extended Z:', Z

  return (X, Y, Z)

# -----------------------------------------------------------------------------
def learn(file):
  print 'Learning %s' % file

  X, Y, Z = csvreadxy(file)
  if X is None or Y is None or Z is None:
    return None

  Xc, Yc, Zc = cleandata(X, Y, Z)
  csvwritexy('fcr_interp.csv', Xc, Yc, Zc)

  mg = np.meshgrid(Xc, Yc)
  XXc = mg[0]
  YYc = mg[1]

  # Plot interplated FCR
  fig = plt.figure()
  axs = Axes3D(fig)
  plt.title('Interpolated FCR')
  axs.set_ylabel('Temp')
  axs.set_xlabel('Aver.wt.')
  axs.set_zlabel('FCR')
  plt.gca().invert_xaxis()
# axs.plot_wireframe(XXc, YYc, Zc.T)
  srf = axs.plot_surface(XXc, YYc, Zc.T, cmap=cm.rainbow, rstride=1, cstride=1)
  plt.colorbar(srf, shrink=0.6, aspect=15)
  plt.savefig('fcr_interp.png')
  sys.stdout.flush()
  plt.show()

  p = optim(Xc, Yc, Zc)

  return p

# =============================================================================
def main(argv):
  prog = os.path.basename(argv[0]).replace('.py', '').replace('.PY', '')
  if len(argv) < 2:
    sys.exit('Usage: %s <file(s).csv>' % prog)

  np.set_printoptions(threshold=np.nan)

  rc = 0
  ps = []

  nfiles = 0
  for arg in argv[1:]:
    files = glob.glob(arg)
    for file in files:
      nfiles += 1
      r = learn(file)
      p = r[0];
      if p is None:
        rc += 1
        continue

      ps.append(p)

  if nfiles == 0:
    sys.exit('No files found')

  # calc global p
  if len(ps):
    p = np.median(np.array(ps))
  else:
    p = 0.0

  return rc

# -----------------------------------------------------------------------------
if __name__ == '__main__':
  rc = main(sys.argv)
  sys.exit(rc)
