---
layout: post
category: swing
folder: MenuWithShadow
title: Menuに半透明の影を付ける
tags: [JMenu, JPopupMenu, UIManager, Border, Robot, Translucent]
author: aterai
pubdate: 2006-10-23T14:11:21+09:00
description: JMenuから開くJPopupMenuにBorderを設定して半透明の影を付けます。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPz0ZEG6I/AAAAAAAAAek/pd0ErBB9eBg/s800/MenuWithShadow.png
comments: true
---
## 概要
`JMenu`から開く`JPopupMenu`に`Border`を設定して半透明の影を付けます。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPz0ZEG6I/AAAAAAAAAek/pd0ErBB9eBg/s800/MenuWithShadow.png %}

## サンプルコード
<pre class="prettyprint"><code>public class CustomPopupMenuUI extends BasicPopupMenuUI {
  public static ComponentUI createUI(JComponent c) {
    return new CustomPopupMenuUI();
  }
  private static boolean isHeavyWeightContainer(Component contents) {
    for (Container p = contents.getParent(); p != null; p = p.getParent()) {
      if ((p instanceof JWindow) || (p instanceof Panel)) {
        return true;
      }
    }
    return false;
  }
  public Popup getPopup(JPopupMenu popup, int x, int y) {
    Popup pp = super.getPopup(popup, x, y);
    JPanel panel = (JPanel) popup.getParent();
    if (isHeavyWeightContainer(panel)) {
      System.out.println("outer");
      Point p = new Point(x, y);
      panel.setBorder(new ShadowBorder(panel, p));
    } else {
      System.out.println("inner");
      panel.setBorder(new ShadowBorderInPanel());
    }
    panel.setOpaque(false);
    return pp;
  }
// ...
</code></pre>

## 解説
上記のサンプルでは、`BasicPopupMenuUI`を継承した`CustomPopupMenuUI`を作成し、`UIManager`で登録しています。

<pre class="prettyprint"><code>UIManager.put("PopupMenuUI","example.CustomPopupMenuUI");
</code></pre>

この`CustomPopupMenuUI`では、ポップアップメニューの表示位置がフレームの内か外かで影のつけ方を切り替えています。

- 内側: ポップアップメニューに半透明の`Border`を設定して影を描画
- 外側: 別`Window`でポップアップメニューが開くため、`Robot`を使って背景画面をキャプチャーし、その上に影を描画して`Border`に設定

<!-- dummy comment line for breaking list -->

~~メニューがフレームの外にはみ出す場合に、メニューをすばやく切り替えたりすると、ゴミが残ることがあるようです。参考リンクの`contrib.com.jgoodies.looks.common.ShadowPopupFactory`を使っても同様のゴミが出る場合があります。~~ 再現しなくなった？ようです。

- - - -
- [JGoodies | We make Java look good and work well](http://www.jgoodies.com/)から`JGoodies`ダウンロードし、以下のように`contrib.com.jgoodies.looks.common.ShadowPopupFactory`を使用して同様の影を表示する方法もある
    
    <pre class="prettyprint"><code>// UIManager.put("PopupMenuUI","example.CustomPopupMenuUI");
    contrib.com.jgoodies.looks.common.ShadowPopupFactory.install();
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
`Web Start`で起動してフレームの外側にメニューが表示される場合は、`java.security.AccessControlException: access denied (java.awt.AWTPermission createRobot)`が発生します。

## 参考リンク
- [Java Swing Hacks #11 ドロップシャドウ付きのメニューを作る](https://www.oreilly.co.jp/books/4873112788/)
- [JGoodies | We make Java look good and work well](http://www.jgoodies.com/)
    - `contrib.com.jgoodies.looks.common.ShadowPopupFactory`
- [JPopupMenuに半透明の影を付ける](https://ateraimemo.com/Swing/DropShadowPopup.html)

<!-- dummy comment line for breaking list -->

## コメント
- ポップアップメニューがフレーム内にあるかどうかではなく、`HeavyWeightContainer`かどうかで影のつけ方を切り替えるように変更。 -- *aterai* 2008-05-29 (木) 16:13:30

<!-- dummy comment line for breaking list -->
