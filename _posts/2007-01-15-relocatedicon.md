---
layout: post
category: swing
folder: RelocatedIcon
title: DesktopManagerでアイコンの再配置
tags: [DesktopManager, JDesktopPane, JInternalFrame]
author: aterai
pubdate: 2007-01-15T12:27:58+09:00
description: JDesktopPaneのサイズが変更されたとき、アイコン化しているJInternalFrameの再配置を行います。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRm01W30I/AAAAAAAAAhc/eBhL-DDKkSo/s800/RelocatedIcon.png
comments: true
---
## 概要
`JDesktopPane`のサイズが変更されたとき、アイコン化している`JInternalFrame`の再配置を行います。[&#91;JDK-4765256&#93; REGRESSION: Icons in JDesktopPane not repositioned when pane is resized - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4765256)からソースコードの大部分を引用しています。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRm01W30I/AAAAAAAAAhc/eBhL-DDKkSo/s800/RelocatedIcon.png %}

## サンプルコード
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
  if (dm instanceof ReIconifyDesktopManager) {
    ReIconifyDesktopManager rdm = (ReIconifyDesktopManager) dm;
    for (JInternalFrame f: desktopPane.getAllFrames()) {
      if (f.isIcon()) {
        rdm.reIconifyFrame(f);
      }
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JDesktopPane`がリサイズされた場合、以下のような手順で再配置を行っています。

1. アイコン化した`JInternalFrame`を一旦、元のサイズと位置に復元
1. アイコン化した場合の位置を再計算
1. 再びアイコン化
1. 再計算した位置への移動

- - - -
`GTKLookAndFeel`の場合、アイコンを移動することは出来ないので、このサンプルには意味がありません。

## 参考リンク
- [&#91;JDK-4765256&#93; REGRESSION: Icons in JDesktopPane not repositioned when pane is resized - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4765256)
    - via: [Swing - JInternalFrame - iconify in a JDesktopPane](https://community.oracle.com/thread/1374482)
- [&#91;JDK-4110799&#93; JInternalFrame icon position unchanged w/ resize - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4110799)
    - [JInternalFrameは最初にアイコン化しておかないと位置が更新されない](http://d.hatena.ne.jp/tori31001/20060901)
    - [JInternalFrameを一番手前に表示](https://ateraimemo.com/Swing/LayeredPane.html)

<!-- dummy comment line for breaking list -->

## コメント
- [&#91;JDK-6647340&#93; Minimized JInternalFrame icons appear in incorrect positions if the main frame is resized - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6647340)は、`1.7.0 b38`で修正済み。 -- *aterai* 2008-12-10 (水) 21:27:26
- `Windows7` + `WindowsLookAndFeel`で`JDesktopPane`の背景が黒になる: [Bug ID: JDK-7012008 JDesktopPane - Wrong background color with Win7+WindowsLnf](https://bugs.openjdk.java.net/browse/JDK-7012008) -- *aterai* 2011-10-04 (火) 16:58:32

<!-- dummy comment line for breaking list -->
