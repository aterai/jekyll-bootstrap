---
layout: post
title: JFrameを半透明化
category: swing
folder: WindowOpacity
tags: [JFrame, Translucent, Transparent, JRootPane, ContentPane, TexturePaint]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-06-14

## JFrameを半透明化
`JFrame`を半透明にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTWw2d9LNI/AAAAAAAAApw/NXG2EcaSv_s/s800/WindowOpacity.png)

### サンプルコード
<pre class="prettyprint"><code>JFrame.setDefaultLookAndFeelDecorated(true);
JFrame frame = new JFrame();
//com.sun.awt.AWTUtilities.setWindowOpacity(frame, .5f);
com.sun.awt.AWTUtilities.setWindowOpaque(frame, false);
frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
JPanel p = new JPanel();
p.add(new JButton("JButton"));
p.setBackground(new Color(.5f,.8f,.5f,.5f));
frame.getContentPane().add(p);
frame.setSize(320, 240);
frame.setLocationRelativeTo(null);
frame.setVisible(true);
</code></pre>

### 解説
`com.sun.awt.AWTUtilities.setWindowOpacity(frame, .5f);`を使って半透明化すると、フレームのタイトルバーや、子コンポーネントまで半透明化されるので、代わりに上記のサンプルでは以下のようにして半透明化を行っています。

- `JFrame.setDefaultLookAndFeelDecorated(true);`で、タイトルバーなどを`JRootPane`に描画
- `com.sun.awt.AWTUtilities.setWindowOpaque(frame, false);`で`JFrame`を完全に透明化
    - `JDK 1.7.0`の場合は、代わりに、`frame.setBackground(new Color(0,0,0,0));`
- `ContentPane`に`setBackground(new Color(.5f,.8f,.5f,.5f));`で半透明の背景色を設定したパネルを追加

<!-- dummy comment line for breaking list -->

### 参考リンク
- [江戸の文様（和風素材・デスクトップ壁紙）](http://www.viva-edo.com/komon/edokomon.html)
- [How to Create Translucent and Shaped Windows (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Other Swing Features)](http://docs.oracle.com/javase/tutorial/uiswing/misc/trans_shaped_windows.html)

<!-- dummy comment line for breaking list -->

### コメント
- そんな簡単にできるんですね！昔画面キャプチャしたり色々苦労した結果断念しました； -- [riki](http://terai.xrea.jp/riki.html) 2010-06-14 (月) 22:57:11
    - `AWTUtilities.setWindowOpaque`などが使えるようになったのは、`6u10`からですが、上記のサンプルみたいなことができるようになったのは、`6u14`から(多分[Bug ID: 6683775 Painting artifacts is seen when panel is made setOpaque(false) for a translucent window](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6683775))みたいですから、最近(ちょうど一年ぐらい)のようです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-06-15 (火) 13:26:11
- 「`Windows 7` + `JDK 1.7.0`」で、このサンプルにある`JComboBox`のドロップダウンリストが正常に描画されない？ 「`Windows XP` + `JDK 1.7.0`」や、「`Windows 7` + `JDK 1.6.0_27`」は問題なし。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-10-18 (火) 19:01:43
- `JDK 1.7.0`では、背景を切り替えたときに前の背景の残像が残る場合がある？ -- [aterai](http://terai.xrea.jp/aterai.html) 2011-10-18 (火) 19:06:07
    - こちらは`((JFrame)w).getContentPane().repaint();`でうまく~~いくが理由が不明…~~ ようなので修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-10-18 (火) 19:19:00
- `JDK 1.7.0_04`で？、透明にした`JFrame`に`JComboBox`を追加すると、ドロップダウンリストがおかしい？ -- [aterai](http://terai.xrea.jp/aterai.html) 2012-05-15 (火) 12:49:23
    - 以下のような`PopupMenuListener`を追加すれば回避できるが…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-05-15 (火) 14:16:17
        
        <pre class="prettyprint"><code>combo.addPopupMenuListener(new PopupMenuListener() {
          @Override public void popupMenuWillBecomeVisible(final PopupMenuEvent e) {
            EventQueue.invokeLater(new Runnable() {
              @Override public void run() {
                JComboBox c = (JComboBox)e.getSource();
                Object o = c.getAccessibleContext().getAccessibleChild(0);
                if(o instanceof JComponent) { //BasicComboPopup
                  ((JComponent)o).repaint();
                }
              }
            });
          }
          @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {}
          @Override public void popupMenuCanceled(PopupMenuEvent e) {}
        });
</code></pre>
    - `7u6`では修正されている。`JDK 1.7.0_06`の`Bug Fixes`に載っている [Bug ID: 7156657 Version 7 doesn't support translucent popup menus against a translucent window](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=7156657) が関係している気がするけど、`Release Fixed`に、`7u6`が無い？ -- [aterai](http://terai.xrea.jp/aterai.html) 2012-09-19 (水) 18:18:48
        - バックポートされた[Bug ID: JDK-2224554 Version 7 doesn't support translucent popup menus against a translucent window](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=2224554)に、`7u6`があった。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-10-29 (火) 19:26:30

<!-- dummy comment line for breaking list -->

