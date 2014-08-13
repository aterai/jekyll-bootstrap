---
layout: post
title: DesktopManagerでアイコンの再配置
category: swing
folder: RelocatedIcon
tags: [DesktopManager, JDesktopPane, JInternalFrame]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-01-15

## DesktopManagerでアイコンの再配置
`JDesktopPane`のサイズが変更されたとき、アイコン化している`JInternalFrame`の再配置を行います。[Bug ID: 4765256 REGRESSION: Icons in JDesktopPane not repositioned when pane is resized](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4765256)からソースコードの大部分を引用しています。


{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRm01W30I/AAAAAAAAAhc/eBhL-DDKkSo/s800/RelocatedIcon.png %}

### サンプルコード
<pre class="prettyprint"><code>class ReIconifyDesktopManager extends DefaultDesktopManager {
  public void reIconifyFrame(JInternalFrame jif) {
    deiconifyFrame(jif);
    Rectangle r = getBoundsForIconOf(jif);
    iconifyFrame(jif);
    jif.getDesktopIcon().setBounds(r);
  }
}
</code></pre>
<pre class="prettyprint"><code>private void doReIconify(JDesktopPane desktopPane) {
  DesktopManager dm = desktopPane.getDesktopManager();
  if(dm instanceof ReIconifyDesktopManager) {
    ReIconifyDesktopManager rdm = (ReIconifyDesktopManager)dm;
    for(JInternalFrame f: desktopPane.getAllFrames()) {
      if(f.isIcon()) rdm.reIconifyFrame(f);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JDesktopPane`がリサイズされた場合、以下のような手順で再配置を行っています。

1. アイコン化した`JInternalFrame`を一旦、元のサイズと位置に復元
1. アイコン化した場合の位置を再計算
1. 再びアイコン化
1. 再計算した位置への移動

- - - -
`GTKLookAndFeel`の場合、アイコンを移動することは出来ないので、このサンプルには意味がありません。

### 参考リンク
- [Bug ID: 4765256 REGRESSION: Icons in JDesktopPane not repositioned when pane is resized](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4765256)
    - via: [Swing - JInternalFrame - iconify in a JDesktopPane](https://forums.oracle.com/thread/1374482)
- [Bug ID: 4110799 JInternalFrame icon position unchanged w/ resize](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4110799)
    - [JInternalFrameは最初にアイコン化しておかないと位置が更新されない](http://d.hatena.ne.jp/tori31001/20060901)
    - [JInternalFrameを一番手前に表示](http://terai.xrea.jp/Swing/LayeredPane.html)

<!-- dummy comment line for breaking list -->

### コメント
- `1.7.0 b38`で修正されているようです。[Bug ID: 6647340 Minimized JInternalFrame icons appear in incorrect positions if the main frame is resized](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6647340) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-12-10 (水) 21:27:26
- `Windows7` + `WindowsLookAndFeel`で`JDesktopPane`の背景が黒になる: [Bug ID: 7008416 JDesktopPane - Wrong background color with Win7+WindowsLnf](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=7008416) -- [aterai](http://terai.xrea.jp/aterai.html) 2011-10-04 (火) 16:58:32

<!-- dummy comment line for breaking list -->

