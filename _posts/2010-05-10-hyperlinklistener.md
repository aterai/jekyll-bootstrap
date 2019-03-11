---
layout: post
category: swing
folder: HyperlinkListener
title: JEditorPaneにリンクを追加
tags: [JEditorPane, Html, HTMLEditorKit, HyperlinkListener, JButton, Hyperlink]
author: aterai
pubdate: 2010-05-10T16:07:06+09:00
description: JEditorPaneに追加したリンクのクリックイベントなどをHyperlinkListenerで処理します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTOK8UtUUI/AAAAAAAAAb8/yiME-hTTlWA/s800/HyperlinkListener.png
comments: true
---
## 概要
`JEditorPane`に追加したリンクのクリックイベントなどを`HyperlinkListener`で処理します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTOK8UtUUI/AAAAAAAAAb8/yiME-hTTlWA/s800/HyperlinkListener.png %}

## サンプルコード
<pre class="prettyprint"><code>final JEditorPane editorPane = new JEditorPane();
editorPane.setEditable(false);
editorPane.setContentType("text/html");
editorPane.putClientProperty(
    JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE);
editorPane.setText(htmlText);
editorPane.addHyperlinkListener(new HyperlinkListener() {
  private String tooltip;
  @Override public void hyperlinkUpdate(HyperlinkEvent e) {
    if (e.getEventType() == HyperlinkEvent.EventType.ACTIVATED) {
      JOptionPane.showMessageDialog(
          editorPane, "You click the link with the URL " + e.getURL());
    } else if (e.getEventType() == HyperlinkEvent.EventType.ENTERED) {
      tooltip = editorPane.getToolTipText();
      URL url = e.getURL();
      editorPane.setToolTipText((url != null) ? url.toExternalForm() : null);
    } else if (e.getEventType() == HyperlinkEvent.EventType.EXITED) {
      editorPane.setToolTipText(tooltip);
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JEditorPane`(`HTMLEditorKit`,編集不可)に挿入したタグ`<a href='...'>...</a>`のクリックなどを受け取る`HyperlinkListener`を追加しています。

- - - -
以下のように、`JButton`などのコンポーネントをアンカータグの代わりに使用する方法もあります。

- `JEditorPane`に`JButton`で作成したリンクを追加
    - 編集可の`JEditorPane`で使用可能
    - リンク文字列の部分選択が不可
    - ~~ベースラインが揃わない~~ `JComponent#setAlignmentY(...)`でテキストベースラインに揃えることが可能
        - サンプルコードは、[JTextPaneに追加するコンポーネントのベースラインを揃える](https://ateraimemo.com/Swing/InsertComponentBaseline.html)に移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Hyperlinkを、JLabel、JButton、JEditorPaneで表示](https://ateraimemo.com/Swing/HyperlinkLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
- いつもお世話になっております。`JEditorPane`に画像ファイルを表示したいですが、画像サイズが揃えていないため、一部表示したり、全部表示したりなどの現状です。そこで、サイズに関係なく、各画像ファイルを全体表示したいです。可能でしょうか？もしかしたら、`JEditorPane`ではなく、別の`Swing`コンポを使う必要があるかなと思います。画像全体表示の方法を教えてください。よろしくお願いいたします。 -- *panda* 2011-07-27 (水) 08:57:42
    - こんばんは。「サイズに関係なく、各画像ファイルを全体表示したい」とは、画像を縮小してすべて同じサイズのサムネイルを表示したいということでしょうか？ 画質にこだわらないなら、以下のように`img`タグの属性で幅と高さを指定する方法があります。 -- *aterai* 2011-07-27 (水) 18:21:59

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
public class ThumbnailTest {
  public JComponent makeUI() {
    StringBuilder sb = new StringBuilder();
    sb.append("&lt;html&gt;&lt;body&gt;aaaaaaaaaaaaaaaaaaaaaa&lt;br /&gt;");
    sb.append("&lt;img width='144' height='120' src='https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTOK8UtUUI/AAAAAAAAAb8/yiME-hTTlWA/s800/HyperlinkListener.png' /&gt;");
    sb.append("&lt;/body&gt;&lt;/html&gt;");
    JEditorPane editorPane = new JEditorPane();
    editorPane.setEditable(false);
    editorPane.setContentType("text/html");
    editorPane.setText(sb.toString());
    JPanel p = new JPanel(new BorderLayout());
    p.add(new JScrollPane(editorPane));
    return p;
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.getContentPane().add(new ThumbnailTest().makeUI());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
}
</code></pre>
