---
layout: post
title: JMenuItemのAccelerator表示を右揃えにする
category: swing
folder: MenuItemAcceleratorAlignment
tags: [JMenuItem, Locale, KeyEvent, ResourceBundle, Alignment]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-09-30

## JMenuItemのAccelerator表示を右揃えにする
JMenuItemのAccelerator表示を右揃えに変更します。

{% download %}

![screenshot](https://lh5.googleusercontent.com/-vl8nnt_tGvQ/UkhDq1YV-VI/AAAAAAAAB2o/B0-hGdv35Ns/s800/MenuItemAcceleratorAlignment.png)

### サンプルコード
<pre class="prettyprint"><code>public static void paintAccText(
    Graphics g, MenuItemLayoutHelper lh, MenuItemLayoutHelper.LayoutResult lr,
    Color disabledForeground, Color acceleratorForeground,
    Color acceleratorSelectionForeground) {
  if(!lh.getAccText().equals("")) {
    ButtonModel model = lh.getMenuItem().getModel();
    g.setFont(lh.getAccFontMetrics().getFont());
    if(!model.isEnabled()) {
      // *** paint the accText disabled
      if(disabledForeground != null) {
        g.setColor(disabledForeground);
        SwingUtilities2.drawString(
            lh.getMenuItem(), g, lh.getAccText(),
            lr.getAccRect().x,
            lr.getAccRect().y + lh.getAccFontMetrics().getAscent());
      }else{
        g.setColor(lh.getMenuItem().getBackground().brighter());
        SwingUtilities2.drawString(
            lh.getMenuItem(), g, lh.getAccText(),
            lr.getAccRect().x,
            lr.getAccRect().y + lh.getAccFontMetrics().getAscent());
        g.setColor(lh.getMenuItem().getBackground().darker());
        SwingUtilities2.drawString(
            lh.getMenuItem(), g, lh.getAccText(),
            lr.getAccRect().x - 1,
            lr.getAccRect().y + lh.getFontMetrics().getAscent() - 1);
      }
    }else{
      // *** paint the accText normally
      if(model.isArmed() ||
         (lh.getMenuItem() instanceof JMenu &amp;&amp; model.isSelected())) {
        g.setColor(acceleratorSelectionForeground);
      }else{
        g.setColor(acceleratorForeground);
      }
      SwingUtilities2.drawString(
          lh.getMenuItem(), g, lh.getAccText(),
          //lr.getAccRect().x, &gt;&gt;&gt;
          lh.getViewRect().x + lh.getViewRect().width
          - lh.getMenuItem().getIconTextGap() - lr.getAccRect().width,
          //&lt;&lt;&lt;
          lr.getAccRect().y + lh.getAccFontMetrics().getAscent());
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`BasicMenuItemUI#paintMenuItem(...)`メソッドをオーバーライドして、`JMenuItem`の`Accelerator`を左寄せではなく、右寄せで表示するように変更しています。

- 注
    - `Web Start`で実行すると`java.security.AccessControlException: access denied ("java.lang.RuntimePermission" "accessClassInPackage.sun.swing")`と例外が発生してメニューが表示されない
    - `sun.swing.MenuItemLayoutHelper`や、`sun.swing.MenuItemLayoutHelper.LayoutResult`などの内部所有のAPIを使用しているので、今後も使用できるか不明
    - `paintText(...)`、`paintCheckIcon(...)`、`paintIcon(...)`、`paintArrowIcon(...)`などの`BasicMenuItemUI`のプライベートなメソッドをほぼそのままコピーして使用している
    - `ComponentOrientation.RIGHT_TO_LEFT`が設定されて、文字列が右から左に配置される場合は考慮していない

<!-- dummy comment line for breaking list -->

- - - -
- `JMenuItem`の`Accelerator`が、`JMenuItem#setLocale(Locale.ENGLISH)`としても変化しない
    - [Bug ID: JDK-6292739 Locale change at runtime doesn't affect text displayed for accelerator keys](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6292739)
- `JDK 1.7.0`から`Locale.getLocale()`が`Locale.JAPAN`などの場合、`KeyEvent#getKeyText(...)`で取得できる文字列が翻訳されている
    - 例: `Space`が「スペース」
- [KeyEvent#getKeyText(int) (Java Platform SE 7)](http://docs.oracle.com/javase/jp/7/api/java/awt/event/KeyEvent.html#getKeyText%28int%29)では、「これらの文字列は`awt.properties`ファイルを変更することによりローカライズが可能です。」となっているが、`%JAVA_HOME%/jre/lib/rt.jar`内に`sun/awt/resources/awt.class`などの優先順位が高いクラスがあるため、`awt_ja.properties`などを作成しても読み込まれない
    - `-Xbootclasspath/p:`などで、`rt.jar`より先に以下のような`sun.awt.resources.awt_ja.class`を読み込むよう指定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>package sun.awt.resources;
import java.util.ListResourceBundle;
//ant package
//cd target
//"%JAVA_HOME%\bin\java" -Xbootclasspath/p:example.jar -jar example.jar
public class awt_ja extends ListResourceBundle {
  @Override protected Object[][] getContents() {
    System.out.println("---- awt_ja ----");
    return new Object[][] { { "AWT.space", "XXXXX" } };
  }
}
</code></pre>

### 参考リンク
- [Swing - Localized Accelorator Keys](https://forums.oracle.com/thread/1364746)

<!-- dummy comment line for breaking list -->

### コメント
