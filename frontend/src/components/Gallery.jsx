export default function Gallery({ isActive }) {
  if (!isActive) return null;

  const images = [
    "/images/photo1.jpg",
    "/images/photo2.jpg",
    "/images/photo3.jpg",
    "/images/photo4.jpg",
  ];

  return (
    <div
      style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))",
        gap: "18px",
        padding: "24px",
        maxWidth: "1100px",
        margin: "0 auto",
      }}
    >
      {images.map((src, index) => (
        <img
          key={index}
          src={src}
          alt={`Memory ${index + 1}`}
          style={{
            width: "100%",
            height: "280px",
            objectFit: "cover",
            borderRadius: "18px",
            boxShadow: "0 12px 30px rgba(0,0,0,0.18)",
            transition: "transform 0.35s ease",
          }}
          onMouseEnter={(e) =>
            (e.currentTarget.style.transform = "scale(1.06)")
          }
          onMouseLeave={(e) =>
            (e.currentTarget.style.transform = "scale(1)")
          }
        />
      ))}
    </div>
  );
}
