---
layout: post
category: swing
folder: DesktopIconSize
title: JInternalFrameをアイコン化した場合のサイズを変更する
tags: [JInternalFrame, JDesktopPane, LookAndFeel]
author: aterai
pubdate: 2016-02-15T00:00:57+09:00
description: JInternalFrameをアイコン化したときに使用されるJDesktopIconのサイズを変更します。
comments: true
---
## 概要
`JInternalFrame`をアイコン化したときに使用される`JDesktopIcon`のサイズを変更します。

{% download https://lh3.googleusercontent.com/-TEU2w7fUDtA/VsCIqEiNtoI/AAAAAAAAONk/VP5SO5nYnuw/s800-Ic42/DesktopIconSize.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("DesktopIcon.width", 150);
//...
JInternalFrame f = new JInternalFrame(t, true, true, true, true);
f.setDesktopIcon(new JInternalFrame.JDesktopIcon(f) {
  @Override public Dimension getPreferredSize() {
    return new Dimension(150, 40);
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JInternalFrame`をアイコン化したときに使用される`JDesktopIcon`のサイズ変更を`LookAndFeel`毎にテストしています。

- `UIManager.put("DesktopIcon.width", DESKTOPICON_WIDTH);`
    - `MetalLookAndFeel`、`WindowsLookAndFeel`などで、`JDesktopIcon`の幅を指定可能
    - `NimbusLookAndFeel`、`MotifLookAndFeel`では効果がない
- `Override: JInternalFrame.JDesktopIcon#getPreferredSize()`
    - `JInternalFrame.JDesktopIcon#getPreferredSize()`メソッドをオーバーライドして、`LookAndFeel`に依存せずにサイズを変更
    - `MotifLookAndFeel`の場合、タイトルバー状ではなくアイコン状なので、`new Dimension(64, 64 + 32)`を使用
- メモ:
    - デフォルト状態の`NimbusLookAndFeel`で、`JDesktopIcon`の高さが`JInternalFrame`によって変化する？
        - 起動時からの`JInternalFrame`: `height=33`、後でボタンから追加した`JInternalFrame`: `height=27`
        - これは無関係？ [JDK-7126823 JInternalFrame.getNormalBounds() returns bad value after iconify/deiconify - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-7126823)
    - `DefaultDesktopManager#getBoundsForIconOf(...)`メソッドをオーバーライドしてサイズ変更することも可能だが、アイコンの位置を計算し直す必要がある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>desktop.setDesktopManager(new DefaultDesktopManager() {
  @Override protected Rectangle getBoundsForIconOf(JInternalFrame f) {
    Rectangle r = super.getBoundsForIconOf(f);
    r.width = 200;
    return r;
  }
});
</code></pre>

## 参考リンク
- [java - Changing DesktopIcon.width on nimbus - Stack Overflow](http://stackoverflow.com/questions/35287367/changing-desktopicon-width-on-nimbus)

<!-- dummy comment line for breaking list -->

## コメント