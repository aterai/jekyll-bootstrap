---
layout: post
title: JInternalFrameを一番手前に表示
category: swing
folder: LayeredPane
tags: [JLayeredPane, JInternalFrame, JDesktopPane]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-06-21

## JInternalFrameを一番手前に表示
`JLayeredPane`を使って、常に一番手前に表示される`JInternalFrame`を作成します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTO8wLpaZI/AAAAAAAAAdM/mML3cGeQwrg/s800/LayeredPane.png %}

### サンプルコード
<pre class="prettyprint"><code>JInternalFrame iframe = new JInternalFrame("AlwaysOnTop",
  true,  //resizable
  false, //closable
  true,  //maximizable
  true); //iconifiable
iframe.setSize(180, 180);
desktop.add(iframe, Integer.valueOf(JLayeredPane.MODAL_LAYER+1));
iframe.setVisible(true);
</code></pre>

### 解説
`JDesktopPane`は、`JLayeredPane`を継承しているので、`JInternalFrame`を追加するレイヤーを指定することができます。
このサンプルでは、タイトルが`AlwaysOnTop`の`JInternalFrame`を、`JLayeredPane.MODAL_LAYER`の一つ上に設定し、他の`JInternalFrame`(ここでは後から追加する`JInternalFrame`)より常に手前に表示されるように設定しています。

### 参考リンク
- メモ:[JInternalFrameは最初にアイコン化しておかないと位置が更新されない](http://d.hatena.ne.jp/tori31001/20060901)
    - [Bug ID: 4110799 JInternalFrame icon position unchanged w/ resize](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4110799)

<!-- dummy comment line for breaking list -->

### コメント
- `JDK 1.5.0`で`JFrame`などは、`frame.setAlwaysOnTop(true)`が使えるようになっています。 -- [aterai](http://terai.xrea.jp/aterai.html) 2004-10-08 (金) 17:00:59
- ありがとうございます。現在`GUI`の作成をしていて、目下この情報を探していました。ありがとうございました -- [G](http://terai.xrea.jp/G.html) 2004-12-24 (金) 12:00:00
    - どういたしまして。 -- [aterai](http://terai.xrea.jp/aterai.html)

<!-- dummy comment line for breaking list -->

