---
layout: post
title: Menuに半透明の影を付ける
category: swing
folder: MenuWithShadow
tags: [JPopupMenu, UIManager, Robot, Translucent]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-10-23

## Menuに半透明の影を付ける
メニューに半透明の影を付けます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTPz0ZEG6I/AAAAAAAAAek/pd0ErBB9eBg/s800/MenuWithShadow.png)

### サンプルコード
<pre class="prettyprint"><code>public class CustomPopupMenuUI extends BasicPopupMenuUI {
  public static ComponentUI createUI(JComponent c) {
    return new CustomPopupMenuUI();
  }
  private static boolean isHeavyWeightContainer(Component contents) {
    for(Container p=contents.getParent();p!=null;p=p.getParent()) {
      if((p instanceof JWindow) || (p instanceof Panel)) {
        return true;
      }
    }
    return false;
  }
  public Popup getPopup(JPopupMenu popup, int x, int y) {
    Popup pp = super.getPopup(popup,x,y);
    JPanel panel = (JPanel)popup.getParent();
    if(isHeavyWeightContainer(panel)) {
        System.out.println("outer");
        Point p = new Point(x,y);
        panel.setBorder(new ShadowBorder(panel,p));
    }else{
        System.out.println("inner");
        panel.setBorder(new ShadowBorderInPanel());
    }
    panel.setOpaque(false);
    return pp;
  }
//......
</code></pre>

### 解説
上記のサンプルでは、`BasicPopupMenuUI`を継承した、`CustomPopupMenuUI`を作成して、これを`UIManager`に登録しています。

<pre class="prettyprint"><code>UIManager.put("PopupMenuUI","example.CustomPopupMenuUI");
</code></pre>

この`CustomPopupMenuUI`では、ポップアップメニューがフレームの中にあるか外にあるかで、影のつけ方を切り替えています。外にある場合は、`Robot`を使って画面をキャプチャしています。

~~メニューがフレームの外にはみ出す場合に、メニューをすばやく切り替えたりすると、ゴミが残ることがあるようです。参考リンクの`contrib.com.jgoodies.looks.common.ShadowPopupFactory`を使っても同様のゴミが出る場合があります。~~ 再現しなくなった？ようです。

- - - -
`contrib.com.jgoodies.looks.common.ShadowPopupFactory`を使用しても、同様の影を作成することができます。[http://www.jgoodies.com/](http://www.jgoodies.com/) などからダウンロードして、以下のように設定してみてください。

<pre class="prettyprint"><code>//UIManager.put("PopupMenuUI","example.CustomPopupMenuUI");
contrib.com.jgoodies.looks.common.ShadowPopupFactory.install();
</code></pre>

- - - -
`Web Start`で起動してフレームの外側にメニューが表示される場合は、`java.security.AccessControlException: access denied (java.awt.AWTPermission createRobot)`が発生します。

### 参考リンク
- [Java Swing Hacks #11 ドロップシャドウ付きのメニューを作る](http://www.oreilly.co.jp/books/4873112788/toc.html)
- [substance: Substance Java look and feel - main page](https://substance.dev.java.net/)
    - contrib.com.jgoodies.looks.common.ShadowPopupFactory
- [JPopupMenuに半透明の影を付ける](http://terai.xrea.jp/Swing/DropShadowPopup.html)

<!-- dummy comment line for breaking list -->

### コメント
- ポップアップメニューがフレーム内にあるかどうかではなく、`HeavyWeightContainer`かどうかで影のつけ方を切り替えるように変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-05-29 (木) 16:13:30

<!-- dummy comment line for breaking list -->
