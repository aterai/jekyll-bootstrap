---
layout: post
title: JToolTipをGlassPane上のコンポーネントで表示する
category: swing
folder: ForceHeavyWeightPopupKey
tags: [JToolTip, GlassPane, ToolTipManager, PopupFactory]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-05-11

## JToolTipをGlassPane上のコンポーネントで表示する
`JToolTip`を`GlassPane`上のコンポーネントに追加した場合でも、手前に表示されるように設定します。主に[Swing - ComboBox scroll and selected/highlight on glasspane](https://forums.oracle.com/thread/1357949)を参考にしています。

{% download %}

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNMeZI4ZI/AAAAAAAAAaY/8XHy9j6jQw0/s800/ForceHeavyWeightPopupKey.png)

### サンプルコード
<pre class="prettyprint"><code>//Swing - ComboBox scroll and selected/highlight on glasspane
//https://forums.oracle.com/thread/1357949
try {
  Class clazz = Class.forName("javax.swing.PopupFactory");
  Field field = clazz.getDeclaredField("forceHeavyWeightPopupKey");
  field.setAccessible(true);
  label2.putClientProperty(field.get(null), Boolean.TRUE);
} catch (Exception ex) {
  ex.printStackTrace();
}
</code></pre>

### 解説
上記のサンプルでは、ボタンをクリックすると、二つのラベルをもつ`GlassPane`が表示されます。

- `111...`(左)
    - `GlassPane`の下に`JToolTip`が表示される
    - 親フレームの外に`JToolTip`がはみ出す場合は、正常に表示される
    - ~~`ToolTipManager.sharedInstance().setLightWeightPopupEnabled(false);`では効果なし？~~
- `222...`(右)
    - 正常に表示されるように、常に、`JToolTip`を重量コンポーネントとして表示している
    - `PopupFactory`クラスの`forceHeavyWeightPopupKey`をリフレクションで取得して、`JComponent#putClientProperty`メソッドで設定
    - [Swing - ComboBox scroll and selected/highlight on glasspane](https://forums.oracle.com/thread/1357949)の`GlassPane`で`JComboBox`のポップアップを正常に表示する方法を引用
    - `ToolTipManager.sharedInstance().setLightWeightPopupEnabled(false);`としておかないと前面に表示されない環境がある？

<!-- dummy comment line for breaking list -->

- - - -
`JDK 1.7.0`の場合は、`javax.swing.PopupFactory.forceHeavyWeightPopupKey`が無くなってしまったので、以下のように
`javax.swing.ClientPropertyKey.PopupFactory_FORCE_HEAVYWEIGHT_POPUP`を使用します。

<pre class="prettyprint"><code>Class clazz = Class.forName("javax.swing.ClientPropertyKey");
Field field = clazz.getDeclaredField("PopupFactory_FORCE_HEAVYWEIGHT_POPUP");
field.setAccessible(true);
combo.putClientProperty(field.get(null), Boolean.TRUE);
</code></pre>

### 参考リンク
- [Swing - ComboBox scroll and selected/highlight on glasspane](https://forums.oracle.com/thread/1357949)
- [JComboBox の GlassPane 上でのレンダリング](http://www.atmarkit.co.jp/bbs/phpBB/viewtopic.php?mode=viewtopic&topic=42615&forum=12)
- [Swing - Why glass pane requires setLightWeightPopupEnabled(false)?](https://forums.oracle.com/thread/1366094)
- [JInternalFrameをModalにする](http://terai.xrea.jp/Swing/ModalInternalFrame.html)

<!-- dummy comment line for breaking list -->

### コメント
- `ToolTipManager.sharedInstance().setLightWeightPopupEnabled(false);`がバージョンによって効かない場合があるらしい。[java - Force HeavyWeight Tooltip with shaped JPanel - Stack Overflow](http://stackoverflow.com/questions/17150483/force-heavyweight-tooltip-with-shaped-jpanel)　 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-06-18 (火) 08:34:11
    - 上記のリンクのサンプルコードだと、`Windows 7` + `JDK 1.7.0_05`: `OK`, `JDK 1.7.0_06`: `NG`。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-06-18 (火) 08:42:24
    - [jdk8/jdk8/jdk: changeset 5453:4acd0211f48b](http://hg.openjdk.java.net/jdk8/jdk8/jdk/rev/4acd0211f48b)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>*** src7u5/javax/swing/PopupFactory.java	Wed May 16 07:54:10 2012
--- src7u6/javax/swing/PopupFactory.java	Fri Aug 10 10:01:16 2012
************** *
*** 203,214 ****
                      popupType = HEAVY_WEIGHT_POPUP;
                      break;
                  }
- } else if (c instanceof Window) {
- Window w = (Window) c;
- if (!w.isOpaque() || w.getOpacity() &lt; 1 || w.getShape() != null) {
- popupType = HEAVY_WEIGHT_POPUP;
- break;
- }
              }
              c = c.getParent();
          }
--- 203,208 ----
</code></pre>

- [Bug ID: 2224554 Version 7 doesn't support translucent popup menus against a translucent window](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=2224554)の修正が関係しているようだ。半透明の`Window`を使わないで、変わった形の`Window`を使う場合は、丁度この記事などのようにリフレクションを使って常に`PopupFactory_FORCE_HEAVYWEIGHT_POPUP`にした方が良さそう。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-06-18 (火) 14:11:40
    - 去年`Swing Dev ML`で議論されている。[<Swing Dev> (8) Review request for 7156657 Version 7 doesn't support translucent popup menus against a translucent window](http://mail.openjdk.java.net/pipermail/swing-dev/2012-June/002096.html) -- [aterai](http://terai.xrea.jp/aterai.html) 2013-06-18 (火) 14:19:21

<!-- dummy comment line for breaking list -->

